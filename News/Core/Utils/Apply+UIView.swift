//
//  Apply+UIView.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

protocol Apply { }

extension Apply {

    ///
    @discardableResult
    func apply(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSObject: Apply { }
