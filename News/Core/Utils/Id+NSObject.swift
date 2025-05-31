//
//  NSObject+id.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import Foundation

extension NSObject {
    
    /// <#Description#>
    static var id: String {
        NSStringFromClass(Self.self)
            .components(separatedBy: ".")
            .last ?? ""
    }
}
