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
        // TOOD: - 셀을 선택하면 다음 화면으로 링크 전송
    }
    
    override func setupAttributes() {
        articleTableView.apply {
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }

    @IBAction func didTapAllButton(_ sender: UIButton) {
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
        force: Bool = false
    ) {
        // 이전에 탭한 카테고리 버튼과 동일하지 않을 경우, 기사를 새로 로드
        if force || previousTappedButton != category {
            articles.removeAll()
            let endpoint = APIEndpoints.latest(
                category: category,
                nextPage: nextPage
            )
            dataTrasnferService.request(endpoint) { result in
                switch result {
                case .success(let value):
                    self.articles = value.results
                case .failure(let error):
                    print(error)
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
            withIdentifier: ArticleTableViewCell.id,
            for: indexPath
        ) as! ArticleTableViewCell
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
