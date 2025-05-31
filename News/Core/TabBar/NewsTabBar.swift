//
//  NewsTabBar.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

///
final class NewsTabBar: UITabBar {
    ///
    private let barHeight: CGFloat = 90
    ///
    private var shapeLayer: CAShapeLayer?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let newShapeLayer = createShapeLayer(rect)
        if let oldShapeLayer = shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: newShapeLayer)
        } else {
            self.layer.insertSublayer(newShapeLayer, at: 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var tabBarFrame = self.frame
        tabBarFrame.size.height = barHeight
        tabBarFrame.origin.y = self.frame.origin.y + self.frame.height - barHeight
        self.frame = tabBarFrame
    }

    ///
    private func createRectPath(_ rect: CGRect) -> UIBezierPath {
        UIBezierPath(roundedRect: rect, cornerRadius: 0)
    }

    ///
    private func createShapeLayer(_ rect: CGRect) -> CAShapeLayer {
        let path = createRectPath(rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemBackground.cgColor
        return shapeLayer
    }
}
