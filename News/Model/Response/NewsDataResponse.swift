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
    
    /// <#Description#>
    var refinedDescription: String {
        description ?? title
    }
    
    /// <#Description#>
    var refinedAuthor: String {
        authors?.first?
            .components(separatedBy: ",")
            .first
        ?? "Unknown"
    }
    
    /// <#Description#>
    func refinedCategory(with category: NewsCategory?) -> String {
        categories.first(where: { $0 == category?.rawValue })
        ?? categories.first
        ?? "Unknown"
    }

    /// <#Description#>
    var formattedPublishedAt: String {
        publishedAt.toString(.MMMdyyyy)
    }
}
