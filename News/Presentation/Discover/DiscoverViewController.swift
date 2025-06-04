//
//  DiscoverViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

final class DiscoverViewController: CoreViewController {

    @IBOutlet weak var categoryBar: CategoryBar!
    @IBOutlet weak var articleTableView: UITableView!

    /// 현재 화면에 표시 중인 뉴스 기사 목록입니다. 변경 시 테이블 뷰를 자동으로 갱신합니다.
    private var articles: [NewsArticleResponse] = [] {
        didSet { articleTableView.reloadData() }
    }

    /// 마지막으로 선택된 카테고리 버튼을 나타냅니다.
    private var previousTappedButton: NewsCategory?

    /// 페이징 처리 활성화 여부입니다.
    var isPagingEnabled: Bool = true

    /// 다음 페이지 요청을 위한 URL입니다.
    private var nextPage: String?

    /// 현재 데이터를 가져오는 중인지 여부를 나타냅니다.
    private var isFetching: Bool = false

    /// 이미 로드한 페이지 URL 목록입니다. 중복 요청을 방지합니다.
    private var loadedNextPage: [String] = []

    /// 네트워크 요청을 처리하는 데이터 전송 서비스입니다.
    private let dataTrasnferService: any DataTransferService = DefaultDataTransferService()

    /// 카테고리 선택 이벤트를 외부로 전달하기 위한 델리게이트입니다.
    weak var delegate: (any DiscoverViewControllerDelegate)?


    override func viewDidLoad() {
        super.viewDidLoad()

        // 뷰가 로드될 시,
        // 최초 한번 강제로 기사 로드하고,
        fetchArticles(force: true)
        // All 버튼이 선택된 상태로 시작하기
        categoryBar.sendAction(nil)
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
        categoryBar.delegate = self

        articleTableView.apply {
            $0.register(
                UINib(nibName: "NewsArticleTableViewCell", bundle: nil),
                forCellReuseIdentifier: NewsArticleTableViewCell.id
            )
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }

    private func didTapCategoryButton(_ category: NewsCategory?) {
        clearAllState(category)
        fetchArticles(category)
    }

    private func clearAllState(_ category: NewsCategory?) {
        if previousTappedButton != category {
            nextPage = nil
            loadedNextPage.removeAll()
            articles.removeAll()
        }
    }

}

extension DiscoverViewController {

    /// 주어진 카테고리에 해당하는 뉴스 기사를 서버로부터 가져옵니다.
    ///
    /// - Parameters:
    ///   - category: 불러올 뉴스의 카테고리 (nil이면 전체 기사)
    ///   - nextPage: 페이지네이션을 위한 다음 페이지 URL (nil이면 첫 페이지)
    ///   - force: 이전에 선택된 카테고리와 동일하더라도 강제로 다시 불러올지 여부
    ///   - completion: 데이터 로드 완료 후 실행할 클로저
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

extension DiscoverViewController: CategoryBarDeletgate {

    func categeryBar(
        _ categeryBar: CategoryBar,
        didSelect category: NewsCategory?
    ) {
        switch category {
        case .politics:
            didTapCategoryButton(.politics)
        case .technology:
            didTapCategoryButton(.technology)
        case .education:
            didTapCategoryButton(.education)
        default: // all
            didTapCategoryButton(nil)
        }

        delegate?.discover(categeryBar, didSelect: category)
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
    /// - 현재 네트워크 요청 중이 아니어야 하며, (`isFetching` 사용)
    /// - `isPagingEnabled`가 참(true)이어야 실행
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = scrollView.contentInset
        let contentHeight = scrollView.contentSize.height + inset.top + inset.bottom
        let contentOffset = scrollView.contentOffset
        let height = scrollView.bounds.height

        if contentOffset.y >= contentHeight - height - 300 {
            if let nextPage = nextPage, !hasLoadedNextPage(nextPage), !isFetching, isPagingEnabled {
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

    private func hasLoadedNextPage(_ nextPage: String) -> Bool {
        loadedNextPage.firstIndex(of: nextPage) != nil
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 || indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
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
        return 160
    }
}
