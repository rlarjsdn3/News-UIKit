//
//  ArticleDetailViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit
import WebKit

class ArticleDetailViewController: CoreViewController {

    @IBOutlet weak var backButton: CircleButton!
    @IBOutlet weak var sharingButton: CircleButton!
    @IBOutlet weak var bookmarkButton: CircleButton!
    @IBOutlet weak var moreButton: CircleButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    /// <#Description#>
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
    }

    private func loadWebPage() {
        if let url = article?.link {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension ArticleDetailViewController: CircleButtonDelegate {

    func circleButton(
        _ button: CircleButton,
        didTappedButton imageName: String,
        for tag: Int
    ) {
        switch button {
        case backButton:
            popViewController()
        case sharingButton:
            shareArticle()
        case bookmarkButton:
            bookmarkArticle()
        default: // more button
            break
        }
    }

    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    private func shareArticle() {
        let item: [Any] = [article!.link]
        let ac = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(ac, animated: true)
    }

    private func bookmarkArticle() {

    }
}

