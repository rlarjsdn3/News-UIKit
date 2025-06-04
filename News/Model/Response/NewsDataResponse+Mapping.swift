//
//  NewsDataResponse+Mapping.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

extension NewsArticleResponse {

    /// 현재 NewsArticleResponse 인스턴스를 기반으로 BookmarkEntity를 생성하고 지정된 Context에 삽입합니다.
    ///
    /// - Parameter viewContext: 생성된 BookmarkEntity를 삽입할 NSManagedObjectContext 인스턴스
    /// - Returns: 변환 및 삽입된 BookmarkEntity 인스턴스
    func toBookmarkEntity(insertInto viewContext: NSManagedObjectContext) -> BookmarkEntity {
        return BookmarkEntity(self, insertInto: viewContext)
    }
}
