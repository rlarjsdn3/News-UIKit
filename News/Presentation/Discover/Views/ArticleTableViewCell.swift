//
//  ArticleTableViewCell.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

typealias NewsArticleResponse = NewsDataResponse.ArticleResponse

final class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    var dataTransferService: (any DataTransferService)?
    private var cancellable: (any NetworkCancellable)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupMenu()
        setupIntialState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupIntialState()
    }
    
    private func setupIntialState() {
        cancellable?.cancel()
        articleImageView.image = nil
        placeholderImageView.isHidden = false
    }

    private func setupMenu() {
        let bookmarkAction = UIAction(
            title: "북마크 추가",
            image: UIImage(systemName: "bookmark")) { _ in
            }
        
        let shareAction = UIAction(
            title: "공유하기",
            image: UIImage(systemName: "square.and.arrow.up")) { _ in
            }
        
        let copyLinkAction = UIAction(
            title: "링크 복사",
            image: UIImage(systemName: "link")) { _ in
            }
        
        let reportAction = UIAction(
            title: "신고하기",
            image: UIImage(systemName: "exclamationmark.bubble"),
            attributes: .destructive) { _ in
            }
        
        let menu = UIMenu(
            title: "",
            children: [
                bookmarkAction,
                shareAction,
                copyLinkAction,
                reportAction
            ]
        )
        
        moreButton.apply {
            $0.menu = menu
            $0.showsMenuAsPrimaryAction = true
        }
    }
}

extension ArticleTableViewCell {
    
    /// <#Description#>
    /// - Parameter article: <#article description#>
    func prepare(
        _ article: NewsArticleResponse,
        with category: NewsCategory?
    ) {
        prepareThumbnail(article.imageUrl)
        categoryLabel.text = article.refinedCategory(with: category)
        contentLabel.text = article.refinedDescription
        authorLabel.text = article.refinedAuthor
        publishedAtLabel.text = article.formattedPublishedAt
        
    }
    
    private func prepareThumbnail(_ url: URL?) {
        if let url = url {
            let endpoint = APIEndpoints.image(url)
            cancellable = dataTransferService?.request(endpoint) { result in
                switch result {
                case .success(let data):
                    self.articleImageView.image = UIImage(data: data)
                    self.placeholderImageView.isHidden = true
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
