//
//  DiscoverViewControllerDelegate.swift
//  News
//
//  Created by 김건우 on 6/5/25.
//

import Foundation

protocol DiscoverViewControllerDelegate: AnyObject {
    ///
    func discover(
        _ categoryBar: CategoryBar,
        didSelect category: NewsCategory?
    )
}
