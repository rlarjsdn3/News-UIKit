//
//  CircleButton.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import UIKit

/// 이미지 기반의 원형 버튼 뷰입니다.
/// 선택/비선택 상태에 따라 이미지가 변경되며, 탭 이벤트를 델리게이트를 통해 전달합니다.
final class CircleButton: UIView, NibLodable {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    /// 선택 상태일 때 표시할 이미지 이름입니다. 변경 시 이미지 뷰가 자동 갱신됩니다.
    @IBInspectable var imageName: String = "bookmark" {
        didSet { updateImage(imageName) }
    }
    
    /// 선택 해제 상태일 때 표시할 이미지 이름입니다. 지정하지 않으면 선택 상태 이미지가 그대로 사용됩니다.
    @IBInspectable var deselectedImageName: String?
    
    /// 버튼의 현재 선택 상태입니다. 상태가 바뀌면 이미지도 자동으로 갱신됩니다.
    var isSelected: Bool = true {
        didSet { updateImageIfDeselectedImageExists(deselectedImageName) }
    }
    
    /// 버튼 탭 이벤트를 전달할 델리게이트 객체입니다.
    weak var delegate: (any CircleButtonDelegate)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib(owner: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAttributes()
    }
    
    private func setupAttributes() {
        button.apply {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.newsSeparator.cgColor
            $0.layer.cornerRadius = self.frame.width / 2
            $0.layer.masksToBounds = true
        }
        imageView.tintColor = .label
    }
    
    @IBAction func touchDownButton(_ sender: Any) {
        imageView.alpha = 0.25
    }
    
    @IBAction func touchUpOutsideButton(_ sender: Any) {
        imageView.alpha = 1.0
    }
    
    @IBAction func touchUpInsideButton(_ sender: Any) {
        toggle()
        imageView.alpha = 1.0
        delegate?.circleButton(
            self,
            didSelect: imageName,
            for: tag
        )
    }
    
}

extension CircleButton {

    /// 현재 선택 상태를 반전시킵니다.
    /// 선택되어 있으면 해제하고, 해제되어 있으면 선택 상태로 전환합니다.
    func toggle() {
        setToggle(!isSelected)
    }

    /// 주어진 값으로 선택 상태를 설정합니다.
    /// - Parameter bool: `true`면 선택 상태, `false`면 해제 상태로 설정됩니다.
    func setToggle(_ bool: Bool) {
        isSelected = bool
    }

    /// 주어진 이미지 이름을 기반으로 이미지 뷰를 업데이트합니다.
    /// 우선적으로 프로젝트 내 이미지에서 찾고, 없으면 시스템 이미지에서 찾습니다.
    /// - Parameter name: 표시할 이미지 이름입니다.
    func updateImage(_ name: String) {
        imageView.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        ?? UIImage(systemName: name)
        ?? nil
    }

    /// 선택 상태에 따라 적절한 이미지(기본 또는 해제용)를 표시합니다.
    /// 해제용 이미지가 지정되어 있을 경우에만 적용됩니다.
    /// - Parameter deselectedImageName: 선택 해제 상태에서 사용할 이미지 이름입니다.
    private func updateImageIfDeselectedImageExists(_ deselectedImageName: String?) {
        if let deselectedImageName = deselectedImageName {
            updateImage(isSelected ? imageName : deselectedImageName)
        }
    }
}
