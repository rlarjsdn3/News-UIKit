//
//  ArticleTableViewCell.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

typealias NewsArticleResponse = NewsDataResponse.ArticleResponse

final class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension ArticleTableViewCell {
    
    /// <#Description#>
    /// - Parameter article: <#article description#>
    func prepare(_ article: NewsArticleResponse) {
        articleImageView.image = UIImage(named: "placeholder")
        categoryLabel.text = article.refinedCategory
        contentLabel.text = article.description
        authorLabel.text = article.refinedAuthor
        publishedAtLabel.text = article.formattedPublishedAt
    }
}
