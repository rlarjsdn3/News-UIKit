//
//  BookmarkEntity+Intializer.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

extension BookmarkEntity {
    
    /// <#Description#>
    /// - Parameters:
    ///   - response: <#response description#>
    ///   - context: <#context description#>
    convenience init(
        _ response: NewsArticleResponse,
        insertInto context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.articleId = response.articleId
        self.title = response.title
        self.category = response.categories
        self.desc = response.description
        self.imageUrl = response.imageUrl
        self.link = response.link
        self.publishedAt = response.publishedAt
        self.title = response.title
    }
}

