//
//  SearchViewController.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class SearchViewController: CoreViewController {

    @IBOutlet weak var searchTableView: ArticleTableView!

    /// 이전 검색 쿼리. 중복 검색을 방지하기 위해 사용됨
    private var previousQuery: String?

    /// 검색된 뉴스 기사 목록. 변경 시 테이블 뷰가 자동으로 리로드됨
    private var articles: [NewsArticleResponse] = [] {
        didSet { searchTableView.reloadData() }
    }

    /// 다음 페이지 요청을 위한 페이지 토큰
    private var nextPage: String?

    /// 현재 데이터 요청 중 여부를 나타냄
    private var isFetching: Bool = false

    /// 중복 페이지 요청을 방지하기 위해 이미 요청된 nextPage 값들을 저장
    private var loadedNextPage: [String] = []

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

    /// 입력된 검색어를 기준으로 뉴스 기사를 검색합니다.
    /// 이전 검색어와 다르고, 비어있지 않은 경우에만 새로 검색을 수행합니다.
    ///
    /// - Parameter query: 사용자가 입력한 검색어
    func search(_ query: String) {
        if previousQuery != query, !query.isEmpty {
            articles.removeAll()
            fetchArticles(query)
            previousQuery = query
        }
    }
}

extension SearchViewController {

    /// 검색어를 기반으로 뉴스 기사를 비동기적으로 가져옵니다.
    /// 페이지네이션을 지원하며, 응답 결과는 내부 상태에 저장됩니다.
    ///
    /// - Parameters:
    ///   - query: 검색할 키워드 문자열
    ///   - nextPage: 다음 페이지를 요청하기 위한 토큰 (기본값은 nil)
    ///   - completion: 요청 완료 후 호출할 클로저 (성공/실패 상관없이 호출됨)
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
    /// - `query`와 `nextPage`가 존재해야 하며,
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

    private func hasLoadedNextPage(_ nextPage: String) -> Bool {
        loadedNextPage.contains(nextPage)
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
