//
//  NewsDataResponse+Mock.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension NewsDataResponse {
    
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
