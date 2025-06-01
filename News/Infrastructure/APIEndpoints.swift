//
//  APIEndpoints.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import Foundation

struct APIEndpoints {
    
    /// 서버로부터 최신 뉴스를 가져오는 Endpoint를 생성합니다.
    ///
    /// - Parameters:
    ///   - query: 선택적인 검색 키워드입니다. 입력하지 않으면 모든 주제의 뉴스를 가져옵니다.
    ///   - category: 선택적인 뉴스 카테고리입니다. 지정하면 해당 카테고리에 해당하는 기사만 가져오며, 지정하지 않으면 다양한 카테고리의 기사를 가져옵니다.
    ///   - nextPage: 선택적인 페이지 토큰입니다. 지정하면 다음 페이지의 결과를 가져오며, 지정하지 않으면 첫 번째 페이지를 가져옵니다.
    ///
    /// - Returns: `"latest"` 경로에서 `NewsDataResponse`를 가져오기 위한 `Endpoint`를 반환합니다.
    ///
    /// 언어는 영어(`en`), 국가는 미국(`us`)으로 설정됩니다. 페이지당 기사 수는 10개입니다.
    /// `nextPage`가 없을 경우 첫 번째 페이지만 가져옵니다.
    static func latest(
        query: String? = nil,
        category: NewsCategory? = nil,
        nextPage: String? = nil
    ) -> Endpoint<NewsDataResponse> {
        var queryParameters: [String: Any] = [:]
        if let query = query {
            queryParameters.updateValue(query, forKey: "q")
        }
        if let category = category {
            queryParameters.updateValue(category.rawValue, forKey: "category")
        }
        if let nextPage = nextPage {
            queryParameters.updateValue(nextPage, forKey: "page")
        }
        
        return Endpoint(
            path: "latest",
            method: .get,
            queryParameters: queryParameters
        )
    }
    
    /// <#Description#>
    /// - Parameter url: <#url description#>
    /// - Returns: <#description#>
    static func image(
        _ url: String
    ) -> Endpoint<Data> {
        return Endpoint(
            baseUrl: url,
            responseDecoder: RawDataResponseDecoder()
        )
    }
    
    /// <#Description#>
    /// - Parameter url: <#url description#>
    /// - Returns: <#description#>
    static func image(
        _ url: URL
    ) -> Endpoint<Data> {
        image(url.absoluteString)
    }
}
