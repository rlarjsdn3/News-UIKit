//
//  InsightNowSection.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import Foundation

/// `InsightNowViewController`에서 사용하는 섹션 구성을 정의하는 열거형입니다.
enum InsightNowSection {

    /// 실시간 트렌딩 뉴스 기사 섹션
    /// - Parameter dataSource: 표시할 뉴스 기사 목록
    case trendingNow(dataSource: [NewsArticleResponse])

    /// 카테고리 바를 포함하는 섹션
    case categoryBar
}
