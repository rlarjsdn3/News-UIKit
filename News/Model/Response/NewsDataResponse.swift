//
//  NewsDataResponse.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import Foundation

typealias NewsArticleResponse = NewsDataResponse.ArticleResponse

struct NewsDataResponse: Decodable {
    /// Status shows the status of your request.
    /// If the request was successful then it shows “success”, in case of error it shows “error”.
    /// In the case of error a code and message property will be displayed.
    let status: String
    
    /// The total number of results available for your request.
    let totalResults: Int
    
    /// The resulting articles.
    let results: [ArticleResponse]
    
    /// To go to the next page, copy the next page code (without quotes),
    /// which can be found at the bottom of the page, and add a new parameter with page
    let nextPage: String?
}

extension NewsDataResponse {
    
    struct ArticleResponse: Decodable {
        /// A unique id for each news article.
        let articleId: String
        /// The title of the news article.
        let title: String
        /// URL of the news article.
        let link: URL
        /// The author of the news article
        let authors: [String]?
        /// A small description of the news article
        let description: String?
        /// The published date of the news article
        let publishedAt: Date
        /// URL of image present in the news articles
        let imageUrl: URL?
        /// The category assigned to the news article by NewsData.io
        let categories: [String]
        
        enum CodingKeys: String, CodingKey {
            case articleId = "article_id"
            case title
            case link
            case authors = "creator"
            case description
            case publishedAt = "pubDate"
            case imageUrl = "image_url"
            case categories = "category"
        }
    }
}

extension NewsDataResponse.ArticleResponse {

    /// description이 존재하면 그대로 사용하고, 없을 경우 title로 대체한 기사 요약 텍스트입니다.
    var refinedDescription: String {
        description ?? title
    }

    /// authors 배열의 첫 번째 항목에서 쉼표 기준으로 분리된 첫 번째 값을 반환합니다.
    /// 없을 경우 "Unknown"을 반환합니다.
    var refinedAuthor: String {
        authors?.first?
            .components(separatedBy: ",")
            .first
        ?? "Unknown"
    }

    /// 주어진 카테고리와 일치하는 첫 번째 항목을 반환하고,
    /// 일치하는 항목이 없으면 전체 카테고리 중 첫 번째를 사용합니다.
    /// 둘 다 없으면 "Unknown"을 반환합니다.
    ///
    /// - Parameter category: 외부에서 선택된 카테고리 (선택적)
    /// - Returns: 사용자에게 표시할 최종 카테고리 문자열
    func refinedCategory(with category: NewsCategory?) -> String {
        categories.first(where: { $0 == category?.rawValue })
        ?? categories.first
        ?? "Unknown"
    }

    /// `publishedAt` 날짜를 "MMM, d yyyy" 형식의 문자열로 변환한 값입니다.
    var formattedPublishedAt: String {
        publishedAt.toString(.MMMdyyyy)
    }
}
