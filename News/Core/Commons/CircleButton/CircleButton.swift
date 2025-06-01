//
//  CircleButton.swift
//  News
//
//  Created by 김건우 on 6/1/25.
//

import UIKit

@IBDesignable
final class CircleButton: UIView, NibLodable {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    /// <#Description#>
    @IBInspectable var imageName: String = "bookmark" {
        didSet { updateImage(imageName) }
    }
    
    /// <#Description#>
    @IBInspectable var deselectedImageName: String?
    
    /// <#Description#>
    var isSelected: Bool = true {
        didSet { updateImageIfDeselectedImageExists(deselectedImageName) }
    }
    
    ///
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
    }
    
    @IBAction func touchDownButton(_ sender: Any) {
        imageView.alpha = 0.25
    }
    
    @IBAction func touchUpOutside(_ sender: Any) {
        imageView.alpha = 1.0
    }
    
    @IBAction func touchUpInsideButton(_ sender: Any) {
        toggle()
        imageView.alpha = 1.0
        delegate?.circleButtonDidTapped(self)
    }
    
}


extension CircleButton {
    
    /// <#Description#>
    func toggle() {
        setToggle(!isSelected)
    }
    
    /// <#Description#>
    /// - Parameter bool: <#bool description#>
    func setToggle(_ bool: Bool) {
        isSelected = !isSelected
    }
    
    /// <#Description#>
    /// - Parameter name: <#name description#>
    func updateImage(_ name: String) {
        imageView.image = UIImage(named: name)
        ?? UIImage(systemName: name)
        ?? nil
    }
    
    /// <#Description#>
    /// - Parameter name: <#name description#>
    private func updateImageIfDeselectedImageExists(_ name: String?) {
        if let deselectedImageName = deselectedImageName {
            updateImage(isSelected ? imageName : deselectedImageName)
        }
    }
}
