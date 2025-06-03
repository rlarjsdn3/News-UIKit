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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellable?.cancel()
        articleImageView.image = nil
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
    private func prepareThumbnail(
        from url: URL?,
        retryCount: Int = 3
    ) {
        if let url = url {
            let endpoint = APIEndpoints.image(url)
            cancellable = dataTransferService?.request(endpoint) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.articleImageView.image = UIImage(data: data)
                    self?.placeholderImageView.isHidden = true
                case .failure(let error):
                    if retryCount > 0 {
                        self?.prepareThumbnail(from: url, retryCount: retryCount - 1)
                    } else {
                        self?.placeholderImageView.isHidden = false
                    }
                }
            }
        }
    }
}
