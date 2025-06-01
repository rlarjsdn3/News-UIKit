//
//  BookmarkEntity+Mapping.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension BookmarkEntity {

    /// <#Description#>
    /// - Returns: <#description#>
    func toNewsArticleResponse() -> NewsArticleResponse {
        return NewsArticleResponse(
            articleId: articleId,
            title: title,
            link: link,
            authors: authors,
            description: desc,
            publishedAt: publishedAt,
            imageUrl: imageUrl,
            categories: categories
        )
    }
}
