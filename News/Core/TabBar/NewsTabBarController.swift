//
//  NewsTabBarController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

final class NewsTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {

        var container1 = AttributeContainer()
        container1.foregroundColor = .systemGray

        var container2 = AttributeContainer()
        container2.foregroundColor = .label

        let standard = UITabBarAppearance()
        standard.stackedLayoutAppearance.normal.iconColor = .systemGray
        standard.compactInlineLayoutAppearance.normal.iconColor = .systemGray
        standard.inlineLayoutAppearance.normal.iconColor = .systemGray

        standard.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        standard.compactInlineLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        standard.inlineLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)

        if let attr = try? Dictionary(container1, including: \.uiKit) {
            standard.stackedLayoutAppearance.normal.titleTextAttributes = attr
            standard.compactInlineLayoutAppearance.normal.titleTextAttributes = attr
            standard.inlineLayoutAppearance.normal.titleTextAttributes = attr
        }

        standard.stackedLayoutAppearance.selected.iconColor = .label
        standard.compactInlineLayoutAppearance.selected.iconColor = .label
        standard.inlineLayoutAppearance.selected.iconColor = .label

        standard.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        standard.compactInlineLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        standard.inlineLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)

        if let attr = try? Dictionary(container2, including: \.uiKit) {
            standard.stackedLayoutAppearance.selected.titleTextAttributes = attr
            standard.compactInlineLayoutAppearance.selected.titleTextAttributes = attr
            standard.inlineLayoutAppearance.selected.titleTextAttributes = attr
        }

        self.tabBar.standardAppearance = standard
    }
}
