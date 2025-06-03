//
//  SearchViewController.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class SearchViewController: CoreViewController {

    @IBOutlet weak var searchTableView: ArticleTableView!

    ///
    private var previousQuery: String?

    ///
    private var articles: [NewsArticleResponse] = [] {
        didSet { searchTableView.reloadData() }
    }

    ///
    private var nextPage: String?
    ///
    private var isFetching: Bool = false
    ///
    private var loadedNextPage: [String] = []
    ///
    private func hasLoadedNextPage(_ nextPage: String) -> Bool {
        loadedNextPage.contains(nextPage)
    }

    private let dataTrasnferService: any DataTransferService = DefaultDataTransferService()

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let vc = segue.destination as? ArticleDetailViewController,
           let indexPath = searchTableView.indexPathForSelectedRow  {
            vc.article = articles[indexPath.row]
        }
    }
    
    /// <#Description#>
    /// - Parameter query: <#query description#>
    func search(_ query: String) {
        if previousQuery != query, !query.isEmpty {
            articles.removeAll()
            fetchArticles(query)
            previousQuery = query
        }
    }
}

extension SearchViewController {

    /// <#Description#>
    /// - Parameters:
    ///   - category: <#category description#>
    ///   - force: <#force description#>
    private func fetchArticles(
        _ query: String,
        nextPage: String? = nil,
        completion: (() -> Void)? = nil
    ) {

        let endpoint = APIEndpoints.latest(
            query: query,
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
}

extension SearchViewController: UITableViewDelegate {

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
            if let nextPage = nextPage,
               let query = previousQuery,
               !hasLoadedNextPage(nextPage),
               !isFetching {

                isFetching = true
                loadedNextPage.append(nextPage)

                fetchArticles(
                    query,
                    nextPage: nextPage
                ) {
                    self.isFetching = false
                }
            }
        }
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

extension SearchViewController: UITableViewDataSource {

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
        print(#function)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsArticleTableViewCell.id,
            for: indexPath
        ) as! NewsArticleTableViewCell
        let targetArticle = articles[indexPath.row]
        cell.dataTransferService = dataTrasnferService
        cell.prepare(targetArticle, with: nil)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 160.0
    }
}
