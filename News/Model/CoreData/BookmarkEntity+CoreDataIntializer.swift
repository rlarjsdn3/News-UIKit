//
//  BookmarkEntity+Intializer.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation
import CoreData

extension BookmarkEntity {
    
    /// NewsArticleResponse 모델을 기반으로 BookmarkEntity를 초기화합니다.
    /// 지정된 NSManagedObjectContext에 엔티티를 삽입합니다.
    ///
    /// - Parameters:
    ///   - response: 변환 대상이 되는 뉴스 기사 응답 모델
    ///   - context: 엔티티를 삽입할 NSManagedObjectContext 인스턴스
    convenience init(
        _ response: NewsArticleResponse,
        insertInto context: NSManagedObjectContext
    ) {
        self.init(context: context)
        self.articleId = response.articleId
        self.title = response.title
        self.categories = response.categories
        self.desc = response.description
        self.imageUrl = response.imageUrl
        self.link = response.link
        self.publishedAt = response.publishedAt
        self.title = response.title
    }
}

