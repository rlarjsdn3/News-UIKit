//
//  NewsDataResponse+Mock.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension NewsDataResponse {
    
    /// 번들 내에 포함된 JSON 파일(`MockNewsDataResponse.json`)을 로드하고 디코딩하여,
    /// `NewsDataResponse` 타입의 모의(mock) 데이터를 제공합니다.
    ///
    /// 테스트나 프리뷰 환경에서 실제 API 호출 없이 사용하기 위해 사용됩니다.
    ///
    /// - Note: 디코딩에 실패하거나 파일이 없을 경우 `fatalError`를 발생시킵니다.
    static let mock: NewsDataResponse = {
        guard let url = Bundle.main.url(forResource: "MockNewsDataResponse", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("can not load MockNewsDataResponse.json")
        }
        
        let decoder = DefaultResponseDecoder()
        guard let mock: NewsDataResponse = try? decoder.decode(data) else {
            fatalError("can not decode MockNewsDataResponse.json")
        }
        return mock
    }()
}
