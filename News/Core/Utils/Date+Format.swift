//
//  Date+Format.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension Date {

    /// 날짜 포맷 문자열을 정의한 열거형입니다.
    enum Format: String {
        /// "MMM, d yyyy" 형식 (예: "Jun, 4 2025")
        case MMMdyyyy = "MMM, d yyyy"
    }

    /// 지정된 형식으로 날짜를 문자열로 변환합니다.
    /// - Parameter format: `Date.Format` 열거형으로 정의된 형식
    /// - Returns: 변환된 날짜 문자열
    func toString(_ format: Format) -> String {
        toString(format.rawValue)
    }

    /// 지정된 포맷 문자열을 사용하여 날짜를 문자열로 변환합니다.
    /// - Parameter format: 날짜 형식 문자열 (예: "yyyy-MM-dd")
    /// - Returns: 변환된 날짜 문자열
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
