//
//  CategoryBarDeletgate.swift
//  News
//
//  Created by 김건우 on 6/2/25.
//

import Foundation

/// 카테고리 바(CategoryBar)에서 카테고리가 선택되었을 때의 동작을 처리하는 델리게이트 프로토콜입니다.
protocol CategoryBarDeletgate: AnyObject {

    /// 카테고리 바에서 카테고리를 선택했을 때 호출됩니다.
    /// - Parameters:
    ///   - categeryBar: 선택이 발생한 CategoryBar 인스턴스
    ///   - category: 선택된 카테고리입니다. "전체"가 선택된 경우에는 `nil`입니다.
    func categeryBar(
        _ categeryBar: CategoryBar,
        didSelect category: NewsCategory?
    )
}
