//
//  Date+Format.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

extension Date {
    
    enum Format: String {
        ///
        case MMMdyyyy = "MMM, d yyyy"
    }
    
    func toString(_ format: Format) -> String {
        toString(format.rawValue)
    }
    
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
