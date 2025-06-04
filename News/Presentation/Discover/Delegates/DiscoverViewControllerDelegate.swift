//
//  DiscoverViewControllerDelegate.swift
//  News
//
//  Created by 김건우 on 6/5/25.
//

import Foundation

protocol DiscoverViewControllerDelegate: AnyObject {

    /// DiscoverViewController 내부의 CategoryBar에서 특정 카테고리가 선택되었을 때 호출됩니다.
    ///
    /// - Parameters:
    ///   - categoryBar: 선택 이벤트가 발생한 CategoryBar 인스턴스
    ///   - category: 사용자가 선택한 뉴스 카테고리 (없을 경우 nil)
    func discover(
        _ categoryBar: CategoryBar,
        didSelect category: NewsCategory?
    )
}
