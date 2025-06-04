//
//  BookmarkEntity+Mapping.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension BookmarkEntity {

    /// 현재 BookmarkEntity 인스턴스를 NewsArticleResponse 모델로 변환합니다.
    ///
    /// Core Data에 저장된 북마크 데이터를 네트워크 응답 모델로 다시 매핑할 때 사용합니다.
    ///
    /// - Returns: BookmarkEntity의 속성을 기반으로 생성된 NewsArticleResponse 인스턴스
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
