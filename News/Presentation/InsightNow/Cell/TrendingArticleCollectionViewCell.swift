//
//  TrendingArticleCollectionViewCell.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

final class TrendingArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!

    private var cancellable: (any NetworkCancellable)?
    var dataTransferService: (any DataTransferService)?

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

extension TrendingArticleCollectionViewCell {
    
    /// <#Description#>
    /// - Parameter article: <#article description#>
    func prepare(_ article: NewsArticleResponse) {
        prepareThumbnail(from: article.imageUrl)
        descriptionLabel.text = article.refinedDescription
        authorLabel.text = article.refinedAuthor
        publishedAtLabel.text = article.formattedPublishedAt

    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - retryCount: <#retryCount description#>
    private func prepareThumbnail(from url: URL?) {
        if let url = url {
            let endpoint = APIEndpoints.image(url)
            cancellable = dataTransferService?.request(endpoint) { [weak self] result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self?.articleImageView.image = image
                        self?.placeholderImageView.isHidden = true
                    } else {
                        self?.articleImageView.isHidden = true
                        self?.placeholderImageView.isHidden = false
                    }
                case .failure(let error):
                    self?.articleImageView.isHidden = true
                    self?.placeholderImageView.isHidden = false
                }
            }
        } else {
            articleImageView.isHidden = true
            placeholderImageView.isHidden = false
        }
    }
}
