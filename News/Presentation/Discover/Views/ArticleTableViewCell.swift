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

    var dataTransferService: (any DataTransferService)?
    private var cancellable: (any NetworkCancellable)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
