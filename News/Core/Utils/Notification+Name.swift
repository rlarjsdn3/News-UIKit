//
//  Notification+Name.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import Foundation

extension Notification.Name {
    /// 사용자가 트렌딩 기사 셀을 탭했을 때 발생하는 알림입니다.
    /// > userInfo: [.indexPath: IndexPath] 형태로 전달됨
    static var didTapTrendingArticleCell = Notification.Name("didTapTrendingArticleCell")
}
