//
//  ViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


@IBDesignable
class MyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        self.configuration = config
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        self.configuration = config
    }
}
