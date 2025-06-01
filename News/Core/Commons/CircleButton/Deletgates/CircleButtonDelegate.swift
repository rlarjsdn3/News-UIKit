//
//  CircleButtonDelegate.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

///
protocol CircleButtonDelegate: AnyObject {
    ///
    func circleButton(
        _ button: CircleButton,
        didTappedButton imageName: String,
        for tag: Int
    )
}
