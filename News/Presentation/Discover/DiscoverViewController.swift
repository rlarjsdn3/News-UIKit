//
//  DiscoverViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

class DiscoverViewController: CoreViewController {

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var politicsButton: UIButton!
    @IBOutlet weak var technologyButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!

    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var politicsLabel: UILabel!
    @IBOutlet weak var technologyLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    
    @IBOutlet weak var allCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var allEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var politicsCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var politicsEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var technologyCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var technologyEqualWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var educationCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var educationEqualWidthConstraint: NSLayoutConstraint!

    private var previousTappedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        didTapAllButton(allButton)
    }

    @IBAction func didTapAllButton(_ sender: UIButton) {
        adjustUnderlineView(
            .defaultHigh,
            .defaultLow,
            .defaultLow,
            .defaultLow
        )
        adjustButtonTitleColor(
            .label,
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .newsSecondaryLabel
        )
    }

    @IBAction func touchDownAllButton(_ sender: UIButton) {
        allLabel.textColor = .systemGray3
    }
    
    @IBAction func didTapPoliticsButton(_ sender: UIButton) {
        adjustUnderlineView(
            .defaultLow,
            .defaultHigh,
            .defaultLow,
            .defaultLow
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .label,
            .newsSecondaryLabel,
            .newsSecondaryLabel
        )
        previousTappedButton = sender
    }

    @IBAction func touchDownPoliticsButton(_ sender: UIButton) {
        politicsLabel.textColor = .systemGray3
    }
    
    @IBAction func didTapTechnologyButton(_ sender: UIButton) {
        adjustUnderlineView(
            .defaultLow,
            .defaultLow,
            .defaultHigh,
            .defaultLow
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .label,
            .newsSecondaryLabel
        )
        previousTappedButton = sender
    }


    @IBAction func touchDownTechnologyButton(_ sender: UIButton) {
        technologyLabel.textColor = .systemGray3
    }

    @IBAction func didTapEducationButton(_ sender: UIButton) {
        adjustUnderlineView(
            .defaultLow,
            .defaultLow,
            .defaultLow,
            .defaultHigh
        )
        adjustButtonTitleColor(
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .newsSecondaryLabel,
            .label
        )
        previousTappedButton = sender
    }

    @IBAction func touchDownEducationButton(_ sender: UIButton) {
        educationLabel.textColor = .systemGray3
    }
    
}

extension DiscoverViewController {

    private func adjustUnderlineView(
        _ priority1: UILayoutPriority,
        _ priority2: UILayoutPriority,
        _ priority3: UILayoutPriority,
        _ priority4: UILayoutPriority
    ) {
        allCenterXConstraint.priority = priority1
        allEqualWidthConstraint.priority = priority1

        politicsCenterXConstraint.priority = priority2
        politicsEqualWidthConstraint.priority = priority2

        technologyCenterXConstraint.priority = priority3
        technologyEqualWidthConstraint.priority = priority3

        educationCenterXConstraint.priority = priority4
        educationEqualWidthConstraint.priority = priority4

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func adjustButtonTitleColor(
        _ color1: UIColor,
        _ color2: UIColor,
        _ color3: UIColor,
        _ color4: UIColor
    ) {
        UIView.animate(withDuration: 0.24) {
            self.allLabel.textColor = color1
            self.politicsLabel.textColor = color2
            self.technologyLabel.textColor = color3
            self.educationLabel.textColor = color4
        }
    }
}
