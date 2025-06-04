//
//  InsightNowViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

final class InsightNowViewController: CoreViewController {
    
    @IBOutlet weak var insightNowTableView: UITableView!
    
    @IBOutlet weak var stickyCategoryBar: CategoryBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var xmarkButton: CircleButton!
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!

    private let dataTransferService: (any DataTransferService) = DefaultDataTransferService()

    private var searchController: SearchViewController?
    private var discoverController: DiscoverViewController?

    private var dataSouce: [InsightNowSection] = [] {
        didSet { insightNowTableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchTrendingNowArticles()
        registerDidTapTrendingArticleNotification()
        // 진짜 '카테고리 바'와 상태를 동일하게 맞추기
        stickyCategoryBar.sendAction(nil)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let vc = segue.destination as? ArticleDetailViewController {
            guard let article = sender as? NewsArticleResponse else { return }
            vc.article = article
        }
    }

    override func setupAttributes() {
        searchBar.apply {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.newsSeparator.cgColor
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }

        insightNowTableView.apply {
            $0.isPagingEnabled = false
            $0.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 8, right: 0)
        }

        containerView.alpha = 0
        stickyCategoryBar.isHidden = true
        stickyCategoryBar.delegate = self
        xmarkButton.delegate = self
    }

    private func registerDidTapTrendingArticleNotification() {
        NotificationCenter.default.addObserver(
            forName: .didTapTrendingArticleCell,
            object: nil,
            queue: .main,
            using: handleDidTapTrendingArticleCell(_:)
        )
    }

    private func unregisterNotificationOberverIfNeeded() {
        NotificationCenter.default.removeObserver(self)
    }

    deinit {
        unregisterNotificationOberverIfNeeded()
    }
}

extension InsightNowViewController {
    
    private func fetchTrendingNowArticles() {
        let endpoint = APIEndpoints.latest()
        dataTransferService.request(endpoint) { [weak self] result in
            switch result {
            case .success(let value):
                self?.dataSouce = [.trendingNow(dataSource: value.results), .categoryBar]
            case .failure(let error):
                self?.dataSouce = [.categoryBar]
                print(error)
            }
        }
    }

    private func handleDidTapTrendingArticleCell(_ notification: Notification) {
        guard let indexPath = notification.userInfo?[.indexPath] as? IndexPath else { return }
        guard case let .trendingNow(dataSource) = dataSouce.first(where: {
            if case .trendingNow(_) = $0 { return true }
            return false
        }) else { return }
        let selectedArticle = dataSource[indexPath.row]
        performSegue(withIdentifier: "navigateToArticleDetail", sender: selectedArticle)
    }
}

extension InsightNowViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        searchController?.search(textField.text ?? "")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleSearchMode(true)
        insightNowTableView.scrollRectToVisible(.init(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    /// <#Description#>
    /// - Parameter searchMode: <#searchMode description#>
    private func toggleSearchMode(_ searchMode: Bool) {
        if searchMode {
            addSearchController()
            searchBarTopConstraint.constant = 0
            searchBarTrailingConstraint.constant = 72
            searchBarHeightConstraint.constant = 50
            searchBar.layer.cornerRadius = 25
            xmarkButton.isHidden = false
            navigationTitleLabel.isHidden = true
        } else{
            removeSearchController()
            searchBarTopConstraint.constant = 72
            searchBarTrailingConstraint.constant = 8
            searchBarHeightConstraint.constant = 60
            searchBar.layer.cornerRadius = 30
            searchField.text = ""
            xmarkButton.isHidden = true
            navigationTitleLabel.isHidden = false
        }

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = searchMode ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    /// <#Description#>
    private func addSearchController() {
        //
        if children.exclude(where: { $0 === searchController }),
           let searchCon = SearchViewController.instantiateViewController(from: "Search") {
            self.searchController = searchCon
            addChild(searchCon, to: containerView)
        }
    }
    
    /// <#Description#>
    private func removeSearchController() {
        if let searchController = searchController {
            removeChild(searchController)
        }
    }

    ///
    private func addDiscoverViewController(to cell: DiscoverTableViewCell) {
        if children.exclude(where: { $0 === discoverController }),
           let discoverCon = DiscoverViewController.instantiateViewController(from: "Discover") {
            self.discoverController = discoverCon
            discoverCon.loadViewIfNeeded()
            discoverCon.delegate = self
            discoverCon.articleTableView.isScrollEnabled = false
            addChild(discoverCon, to: cell.containerView)
        }
    }

    /// <#Description#>
    private func removeDiscoverController() {
        if let discoverController = discoverController {
            removeChild(discoverController)
        }
    }
}

extension InsightNowViewController: CircleButtonDelegate {

    func circleButton(
        _ button: CircleButton,
        didTappedButton imageName: String,
        for tag: Int
    ) {
        searchField.endEditing(true)
        toggleSearchMode(false)
    }
}

extension InsightNowViewController: CategoryBarDeletgate {

    func categeryBar(
        _ categeryBar: CategoryBar,
        didSelect category: NewsCategory?
    ) {
        discoverController?.categoryBar.sendAction(category)
    }
}

extension InsightNowViewController: DiscoverViewControllerDelegate {

    func discover(
        _ categoryBar: CategoryBar,
        didSelect category: NewsCategory?
    ) {
        stickyCategoryBar.setSelection(category)
    }
}

extension InsightNowViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = scrollView.contentInset
        let contentOffsetY = scrollView.contentOffset.y + inset.top

        // 검색 바 투명도 조절
        let alpha = 1 - contentOffsetY / 30
        searchBar.alpha = alpha < 0 ? 0 : alpha

        // 검색 바 스케일 조절
        let rawScale = 1 - contentOffsetY / 200
        let scalingFactor = (1 * rawScale) >= 0.925 ? (1 * rawScale) : 0.925
        let clampedScale = scalingFactor >= 1 ? 1 : scalingFactor
        searchBar.transform = CGAffineTransform(scaleX: clampedScale, y: clampedScale)
        
        // Sticky 카테고리 바
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = insightNowTableView.cellForRow(at: indexPath) {
            let shouldStikcy =  contentOffsetY > cell.frame.minY + inset.top + 28
            stickyCategoryBar.isHidden = !shouldStikcy
        }
    }
}

extension InsightNowViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return dataSouce.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch dataSouce[indexPath.item] {
        case let .trendingNow(articles):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrendingNowTableViewCell.id,
                for: indexPath
            ) as! TrendingNowTableViewCell
            cell.dataTransferService = dataTransferService
            cell.trendingArticles = articles
            return cell
            
        case .categoryBar:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiscoverTableViewCell.id,
                for: indexPath
            ) as! DiscoverTableViewCell
            UIView.performWithoutAnimation {
                addDiscoverViewController(to: cell)
            }
            return cell
        }
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch dataSouce[indexPath.row] {
        case .trendingNow(_):
            return UITableView.automaticDimension
        case .categoryBar:
            return 1700
            // 🟡 셀 내부의 tableView 콘텐츠 크기에 맞게 동적으로 높이를 계산해야 하지만,
            // 현재는 고정된 높이를 임시로 반환하고 있음
        }
    }
}
