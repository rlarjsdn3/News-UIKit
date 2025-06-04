//
//  CircleButtonDelegate.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import Foundation

/// CircleButton이 탭 되었을 때의 동작을 위임받기 위한 델리게이트 프로토콜입니다.
protocol CircleButtonDelegate: AnyObject {

    /// CircleButton이 탭되었을 때 호출됩니다.
    /// - Parameters:
    ///   - button: 탭된 CircleButton 인스턴스
    ///   - imageName: 버튼에 설정된 이미지 이름
    ///   - tag: 버튼에 설정된 태그 값
    func circleButton(
        _ button: CircleButton,
        didSelect imageName: String,
        for tag: Int
    )
}
