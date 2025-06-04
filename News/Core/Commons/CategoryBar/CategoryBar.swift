//
//  CategoryBar.swift
//  News
//
//  Created by 김건우 on 6/2/25.
//

import UIKit

/// 뉴스 카테고리를 선택할 수 있는 버튼 및 라벨을 포함한 사용자 정의 카테고리 바 뷰입니다.
/// 버튼을 선택하면 델리게이트를 통해 선택된 카테고리를 외부로 전달합니다.
final class CategoryBar: UIView, NibLodable {

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

    /// 카테고리 선택 이벤트를 전달할 델리게이트입니다.
    weak var delegate: (any CategoryBarDeletgate)?

    /// 현재 선택된 카테고리입니다.
    private(set) var selectedCategory: NewsCategory?

    /// 델리게이트 호출 여부를 제어하는 플래그입니다.
    private var executeDelegate: Bool = true

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib(owner: self)
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
        selectedCategory = nil
        if executeDelegate { delegate?.categeryBar(self, didSelect: nil) }
    }

    @IBAction func touchDownAllButton(_ sender: UIButton) {
        allLabel.textColor = .systemGray3
    }

    @IBAction func touchUpOutsideAllButton(_ sender: Any) {
        allLabel.textColor = (selectedCategory == nil) ? .label : .newsSecondaryLabel
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
        selectedCategory = .politics
        if executeDelegate { delegate?.categeryBar(self, didSelect: .politics) }
    }

    @IBAction func touchDownPoliticsButton(_ sender: UIButton) {
        politicsLabel.textColor = .systemGray3
    }

    @IBAction func touchUpOutsidePoliticsButton(_ sender: Any) {
        politicsLabel.textColor = (selectedCategory == .politics) ? .label : .newsSecondaryLabel
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
        selectedCategory = .technology
        if executeDelegate { delegate?.categeryBar(self, didSelect: .technology) }
    }


    @IBAction func touchDownTechnologyButton(_ sender: UIButton) {
        technologyLabel.textColor = .systemGray3
    }

    @IBAction func touchUpOutsideTechnologyButton(_ sender: Any) {
        technologyLabel.textColor = (selectedCategory == .technology) ? .label : .newsSecondaryLabel
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
        selectedCategory = .education
        if executeDelegate { delegate?.categeryBar(self, didSelect: .education) }
    }

    @IBAction func touchDownEducationButton(_ sender: UIButton) {
        educationLabel.textColor = .systemGray3
    }

    @IBAction func touchUpOutsideEducationButton(_ sender: Any) {
        educationLabel.textColor = (selectedCategory == .education) ? .label : .newsSecondaryLabel
    }
    
    /// 주어진 카테고리에 해당하는 버튼을 내부적으로 터치한 것처럼 처리하고,
    /// 델리게이트를 통해 선택 이벤트를 외부로 전달합니다.
    /// - Parameter category: 선택할 뉴스 카테고리. `nil`일 경우 '전체'로 간주됩니다.
    func sendAction(_ category: NewsCategory?) {
        switch category {
        case .education:
            didTapEducationButton(educationButton)
        case .technology:
            didTapTechnologyButton(technologyButton)
        case .politics:
            didTapPoliticsButton(politicsButton)
        default: // all
            didTapAllButton(allButton)
        }
    }
    
    /// 주어진 카테고리에 해당하는 버튼을 선택 상태로 설정하지만,
    /// 델리게이트 호출은 생략하여 외부에 알리지 않습니다.
    /// - Parameter category: 설정할 뉴스 카테고리. `nil`일 경우 '전체'로 간주됩니다.
    func setSelection(_ category: NewsCategory?) {
        executeDelegate = false
        switch category {
        case .education:
            didTapEducationButton(educationButton)
        case .technology:
            didTapTechnologyButton(technologyButton)
        case .politics:
            didTapPoliticsButton(politicsButton)
        default: // all
            didTapAllButton(allButton)
        }
        executeDelegate = true
    }
}

extension CategoryBar {

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
            self.layoutIfNeeded()
        }
    }

    private func adjustButtonTitleColor(
        _ color1: UIColor,
        _ color2: UIColor,
        _ color3: UIColor,
        _ color4: UIColor
    ) {
        UIView.animate(withDuration: 0.25) {
            self.allLabel.textColor = color1
            self.politicsLabel.textColor = color2
            self.technologyLabel.textColor = color3
            self.educationLabel.textColor = color4
        }
    }

}

