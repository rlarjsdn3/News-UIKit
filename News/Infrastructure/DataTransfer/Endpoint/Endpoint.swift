//
//  Endpoint.swift
//  DataTransferService
//
//  Created by 김건우 on 5/30/25.
//

import Foundation

/// HTTP 요청에서 사용되는 메서드 타입을 정의한 열거형입니다.
enum HttpMethodType: String {
    /// 서버로부터 리소스를 조회할 때 사용하는 GET 메서드입니다.
    case get = "GET"
    /// 서버에 데이터를 생성할 때 사용하는 POST 메서드입니다.
    case post = "POST"
    /// 서버의 리소스를 수정할 때 사용하는 PUT 메서드입니다.
    case put = "PUT"
}

struct Endpoint<R>: ResponseRequestable {

    typealias Response = R

    let baseUrl: String?
    let path: String
    let method: HttpMethodType
    let headerParameters: [String : String]
    let queryParametersEncodable: (any Encodable)?
    let queryParameters: [String : Any]
    let bodyParametersEncodable: (any Encodable)?
    let bodyParameters: [String : Any]
    let bodyEncoder: any BodyEncoder
    let responseDecoder: any ResponseDecoder
    
    /// Endpoint 객체를 초기화합니다.
    ///
    /// - Parameters:
    ///   - baseUrl: 요청할 API 기본 주소입니다.
    ///   - path: 요청할 API 경로입니다. (예: "/books")
    ///   - method: HTTP 요청 메서드입니다. (예: .get, .post)
    ///   - headerParameters: 요청에 사용할 HTTP 헤더 필드입니다.
    ///   - queryParametersEncodable: Encodable 객체를 쿼리 파라미터로 인코딩할 때 사용됩니다.
    ///   - queryParameters: Dictionary 형태의 쿼리 파라미터입니다. Encodable 객체가 없을 때 사용됩니다.
    ///   - bodyParametersEncodable: Encodable 객체를 HTTP 바디로 인코딩할 때 사용됩니다.
    ///   - bodyParameters: Dictionary 형태의 바디 파라미터입니다. Encodable 객체가 없을 때 사용됩니다.
    ///   - bodyEncoder: HTTP 바디 파라미터를 인코딩할 때 사용할 인코더입니다.
    ///   - responseDecoder: 응답 데이터를 디코딩할 때 사용할 디코더입니다.
    init(
        baseUrl: String? = nil,
        path: String = "",
        method: HttpMethodType = .get,
        headerParameters: [String : String] = [:],
        queryParametersEncodable: (any Encodable)? = nil,
        queryParameters: [String : Any] = [:],
        bodyParametersEncodable: (any Encodable)? = nil,
        bodyParameters: [String : Any] = [:],
        bodyEncoder: any BodyEncoder = DefaultBodyEncoder(),
        responseDecoder: any ResponseDecoder = DefaultResponseDecoder()
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}
