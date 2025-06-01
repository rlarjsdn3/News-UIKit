//
//  NewsDataResponse+Mapping.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

extension NewsArticleResponse {
    
    /// <#Description#>
    /// - Parameter viewContext: <#viewContext description#>
    /// - Returns: <#description#>
    func toBookmarkEntity(insertInto viewContext: NSManagedObjectContext) -> BookmarkEntity {
        return BookmarkEntity(self, insertInto: viewContext)
    }
}
