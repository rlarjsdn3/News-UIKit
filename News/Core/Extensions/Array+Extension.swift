//
//  Array+Extension.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import Foundation

extension Array {
    
    /// <#Description#>
    /// - Parameter predicate: <#predicate description#>
    /// - Returns: <#description#>
    func exclude(where predicate: (Array.Element) throws -> Bool) rethrows -> Bool {
        try !self.contains(where: predicate)
    }
}
