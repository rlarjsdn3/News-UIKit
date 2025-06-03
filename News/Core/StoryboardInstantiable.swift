//
//  StoryboardInstantiable.swift
//  News
//
//  Created by 김건우 on 6/3/25.
//

import UIKit

protocol StoryboardInstantiable {
    ///
    static var name: String { get }
    ///
    static func instantiateViewController(from storyboardName: String) -> Self?
}

extension StoryboardInstantiable where Self: UIViewController {
    
    ///
    static var name: String {
        String(describing: Self.self)
    }
    
    ///
    static func storyboard(_ name: String) -> UIStoryboard {
        let bundle = Bundle(for: Self.self)
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    ///
    static func instantiateViewController(from storyboardName: String = Self.name) -> Self? {
        guard let vc = Self.storyboard(storyboardName).instantiateInitialViewController() as? Self else {
            return nil
        }
        return vc
    }
}
