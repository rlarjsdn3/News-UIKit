//
//  UIViewController+Extension.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

extension UIViewController {
    
    /// <#Description#>
    /// - Parameters:
    ///   - vc: <#viewController description#>
    ///   - view: <#view description#>
    func addChild(
        _ vc: UIViewController,
        to container: UIView
    ) {
        self.addChild(vc)
        container.addSubview(vc.view)
        vc.view.frame = container.bounds
        vc.didMove(toParent: self)
    }
    
    /// <#Description#>
    /// - Parameter vc: <#viewController description#>
    func removeChild(_ vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.removeFromParent()
        vc.view.removeFromSuperview()
    }
}
