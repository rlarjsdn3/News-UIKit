//
//  NewsTabBar.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

/// 커스텀 디자인을 적용한 탭 바입니다.
/// 고정된 높이와 배경 모양을 설정하며, traitCollection이 변경되면 색상도 자동으로 갱신됩니다.
final class NewsTabBar: UITabBar {

    /// 탭 바의 고정 높이입니다.
    private let barHeight: CGFloat = 94

    /// 배경 모양을 그리는 Shape Layer입니다.
    private var shapeLayer: CAShapeLayer?

    /// 탭 바의 외형을 커스텀으로 그립니다.
    /// 기존 shapeLayer가 있다면 교체하고, 없으면 새로 삽입합니다.
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let newShapeLayer = createShapeLayer(rect)
        if let oldShapeLayer = shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: newShapeLayer)
        } else {
            self.layer.insertSublayer(newShapeLayer, at: 0)
        }
        self.shapeLayer = newShapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var tabBarFrame = self.frame
        tabBarFrame.size.height = barHeight
        tabBarFrame.origin.y = self.frame.origin.y + self.frame.height - barHeight
        self.frame = tabBarFrame
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateColor()
        self.setNeedsDisplay()
    }

    /// 사각형 모양의 베지어 패스를 생성합니다.
    /// - Parameter rect: 기준이 되는 사각형
    /// - Returns: 생성된 베지어 패스
    private func createRectPath(_ rect: CGRect) -> UIBezierPath {
        UIBezierPath(roundedRect: rect, cornerRadius: 0)
    }

    /// 배경 그리기에 사용할 Shape Layer를 생성합니다.
    /// - Parameter rect: 베지어 패스를 그릴 기준 사각형
    /// - Returns: 배경용 CAShapeLayer 객체
    private func createShapeLayer(_ rect: CGRect) -> CAShapeLayer {
        let path = createRectPath(rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        return shapeLayer
    }

    /// 현재 trait 환경에 맞춰 shape layer의 색상을 갱신합니다.
    private func updateColor() {
        self.shapeLayer?.fillColor = UIColor.systemBackground.cgColor
    }
}
