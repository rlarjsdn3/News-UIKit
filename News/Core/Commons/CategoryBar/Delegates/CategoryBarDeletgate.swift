//
//  CategoryBarDeletgate.swift
//  News
//
//  Created by 김건우 on 6/2/25.
//

import Foundation

protocol CategoryBarDeletgate: AnyObject {

    /// <#Description#>
    /// - Parameters:
    ///   - categeryBar: <#categeryBar description#>
    ///   - category: <#category description#>
    func categeryBar(
        _ categeryBar: CategoryBar,
        didSelect category: NewsCategory?
    )
}
