//
//  Array+Extension.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import Foundation

extension Array {

    /// 주어진 조건을 만족하는 요소가 배열에 포함되어 있지 않은지 확인합니다.
    ///
    /// `contains(where:)`의 반대 동작을 수행하며, 조건을 만족하는 요소가 없으면 `true`를 반환합니다.
    ///
    /// - Parameter predicate: 각 요소에 대해 평가할 조건 클로저입니다.
    /// - Returns: 조건을 만족하는 요소가 하나도 없으면 `true`, 하나라도 있으면 `false` 반환
    func exclude(where predicate: (Array.Element) throws -> Bool) rethrows -> Bool {
        try !self.contains(where: predicate)
    }
}
