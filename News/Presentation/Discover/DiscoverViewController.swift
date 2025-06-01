//
//  DiscoverViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

final class DiscoverViewController: CoreViewController {

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var politicsButton: UIButton!
    @IBOutlet weak var technologyButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!

    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var politicsLabel: UILabel!
    @IBOutlet weak var technologyLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    
    @IBOutlet weak var allCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var allEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var politicsCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var politicsEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var technologyCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var technologyEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var educationCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var articleTableView: UITableView!
    
    ///
    private var articles: [NewsArticleResponse] = [] {
        didSet { articleTableView.reloadData() }
    }
    ///
    private var previousTappedButton: NewsCategory?
    
    ///
    private var nextPage: String?
    ///
    private var isFetching: Bool = false
    ///
    private var loadedNextPage: [String] = []
    ///
    private func hasLoadedNextPage(_ nextPage: String) -> Bool {
        loadedNextPage.firstIndex(of: nextPage) != nil
    }

    private let dataTrasnferService: any DataTransferService = DefaultDataTransferService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰가 로드될 시,
        // 최초 한번 강제로 기사 로드하고,
        fetchArticles(force: true)
        // All 버튼이 선택된 상태로 시작
        didTapAllButton(allButton)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let vc = segue.destination as? ArticleDetailViewController,
           let indexPath = articleTableView.indexPathForSelectedRow  {
            vc.article = articles[indexPath.row]
        }
    }
    
    override func setupAttributes() {
        articleTableView.apply {
            $0.register(
                UINib(nibName: "NewsArticleTableViewCell", bundle: nil),
                forCellReuseIdentifier: NewsArticleTableViewCell.id
            )
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }

    @IBAction func didTapAllButton(_ sender: UIButton) {
        nextPage = nil
        loadedNextPage.removeAll()
        articles.removeAll()
        fetchArticles(nil)
        
        adjustUnderlineView(
            .defaultHigh,
            .defaultLow,
            .defaultLow,
            .defaultLow
        )
        adjustButtonTitleColor(
            .label,
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .newsSecondaryLabel
        )
    }

    @IBAction func touchDownAllButton(_ sender: UIButton) {
        allLabel.textColor = .systemGray3
    }
    
    @IBAction func didTapPoliticsButton(_ sender: UIButton) {
        nextPage = nil
        loadedNextPage.removeAll()
        articles.removeAll()
        fetchArticles(.politics)
        
        adjustUnderlineView(
            .defaultLow,
            .defaultHigh,
            .defaultLow,
            .defaultLow
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .label,
            .newsSecondaryLabel,
            .newsSecondaryLabel
        )
    }

    @IBAction func touchDownPoliticsButton(_ sender: UIButton) {
        politicsLabel.textColor = .systemGray3
    }
    
    @IBAction func didTapTechnologyButton(_ sender: UIButton) {
        nextPage = nil
        loadedNextPage.removeAll()
        articles.removeAll()
        fetchArticles(.technology)
        
        adjustUnderlineView(
            .defaultLow,
            .defaultLow,
            .defaultHigh,
            .defaultLow
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .label,
            .newsSecondaryLabel
        )
    }


    @IBAction func touchDownTechnologyButton(_ sender: UIButton) {
        technologyLabel.textColor = .systemGray3
    }

    @IBAction func didTapEducationButton(_ sender: UIButton) {
        nextPage = nil
        loadedNextPage.removeAll()
        articles.removeAll()
        fetchArticles(.education)
        
        adjustUnderlineView(
            .defaultLow,
            .defaultLow,
            .defaultLow,
            .defaultHigh
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .label
        )
    }

    @IBAction func touchDownEducationButton(_ sender: UIButton) {
        educationLabel.textColor = .systemGray3
    }
    
}

extension DiscoverViewController {

    private func adjustUnderlineView(
        _ priority1: UILayoutPriority,
        _ priority2: UILayoutPriority,
        _ priority3: UILayoutPriority,
        _ priority4: UILayoutPriority
    ) {
        allCenterXConstraint.priority = priority1
        allEqualWidthConstraint.priority = priority1

        politicsCenterXConstraint.priority = priority2
        politicsEqualWidthConstraint.priority = priority2

        technologyCenterXConstraint.priority = priority3
        technologyEqualWidthConstraint.priority = priority3

        educationCenterXConstraint.priority = priority4
        educationEqualWidthConstraint.priority = priority4

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func adjustButtonTitleColor(
        _ color1: UIColor,
        _ color2: UIColor,
        _ color3: UIColor,
        _ color4: UIColor
    ) {
        UIView.animate(withDuration: 0.24) {
            self.allLabel.textColor = color1
            self.politicsLabel.textColor = color2
            self.technologyLabel.textColor = color3
            self.educationLabel.textColor = color4
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - category: <#category description#>
    ///   - force: <#force description#>
    private func fetchArticles(
        _ category: NewsCategory? = nil,
        nextPage: String? = nil,
        force: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        // 이전에 탭한 카테고리 버튼과 동일하지 않을 경우, 기사를 새로 로드
        if force || previousTappedButton != category {
            let endpoint = APIEndpoints.latest(
                category: category,
                nextPage: nextPage
            )
            dataTrasnferService.request(endpoint) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.articles.append(contentsOf: value.results)
                    self?.nextPage = value.nextPage
                    completion?()
                case .failure(let error):
                    print(error)
                    completion?()
                }
            }
        }
        previousTappedButton = category
    }
}

extension DiscoverViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: "navigateToArticleDetail",
            sender: nil
        )
    }
    
    /// 사용자가 테이블 뷰를 스크롤할 때 호출되며, 현재 스크롤 위치에 따라 다음 페이지 데이터를 요청합니다.
    ///
    /// `contentOffset.y >= contentHeight - height - 300`는
    /// 현재 스크롤 위치가 전체 콘텐츠 하단에서 300pt 이내로 도달했는지를 확인하여,
    /// 해당 조건을 만족할 때 다음 페이지 데이터를 요청하도록 합니다.
    ///
    /// - `nextPage`가 존재해야 하며,
    /// - 중복 요청을 막기 위해 `loadedNextPage`에 없어야 하며,
    /// - 현재 네트워크 요청 중이 아닐 때만 실행 (`isFetching` 사용)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = scrollView.contentInset
        let contentHeight = scrollView.contentSize.height + inset.top + inset.bottom
        let contentOffset = scrollView.contentOffset
        let height = scrollView.bounds.height

        if contentOffset.y >= contentHeight - height - 300 {
            if let nextPage = nextPage, !hasLoadedNextPage(nextPage), !isFetching {
                isFetching = true
                loadedNextPage.append(nextPage)

                fetchArticles(
                    previousTappedButton,
                    nextPage: nextPage,
                    force: true
                ) {
                    self.isFetching = false
                }
            }
        }
    }
}

extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return articles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsArticleTableViewCell.id,
            for: indexPath
        ) as! NewsArticleTableViewCell
        let targetArticle = articles[indexPath.row]
        cell.dataTransferService = dataTrasnferService
        cell.prepare(targetArticle, with: previousTappedButton)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 160.0
    }
}
