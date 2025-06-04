//
//  ArticleDetailViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit
import WebKit

final class ArticleDetailViewController: CoreViewController {

    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var sharingButton: CircleButton!
    @IBOutlet weak var bookmarkButton: CircleButton!
    @IBOutlet weak var moreButton: CircleButton!
    
    @IBOutlet weak var webView: WKWebView!

    private let bookmarkStorage: any BookmarkStorage = DefaultBookmarkStorage()

    ///
    var article: NewsArticleResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebPage()
    }

    override func setupAttributes() {
        super.setupAttributes()

        backButton.delegate = self
        sharingButton.delegate = self
        bookmarkButton.delegate = self
        moreButton.delegate = self

        setupBookmarkButtonState()
    }

    private func loadWebPage() {
        if let url = article?.link {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    private func setupBookmarkButtonState() {
        guard let entities = try? bookmarkStorage.fetchBookmarkArticles() else {
            return
        }

        if let _ = entities.first(where: { $0.articleId == article?.articleId }) {
            bookmarkButton.setToggle(true)
        } else {
            bookmarkButton.setToggle(false)
        }
    }
}

extension ArticleDetailViewController: CircleButtonDelegate {

    func circleButton(
        _ button: CircleButton,
        didSelect imageName: String,
        for tag: Int
    ) {
        switch button {
        case backButton:
            didTappedBackButton()
        case sharingButton:
            didTappedSharingButton()
        case bookmarkButton:
            didTappedBookmarkButton()
        default: // more button
            break
        }
    }

    private func didTappedBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func didTappedSharingButton() {
        let item: [Any] = [article!.link]
        let ac = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(ac, animated: true)
    }

    private func didTappedBookmarkButton() {
        guard let article else { return }
        // 북마크 버튼을 off로 토글하면 (on -> off)
        if !bookmarkButton.isSelected {
            do {
                try bookmarkStorage.deleteBookmarkArticle(article)
            } catch {
                print(error)
            }
        // 북마크 버튼을 on으로 토글하면 (off -> on)
        } else {
            bookmarkStorage.insertBookmarkArticles(article)
        }
    }
}

