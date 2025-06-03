//
//  InsightNowViewController.swift
//  News
//
//  Created by 김건우 on 5/31/25.
//

import UIKit

final class InsightNowViewController: CoreViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var xmarkButton: CircleButton!
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!

    private var searchController: SearchViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupAttributes() {
        xmarkButton.delegate = self

        searchBar.apply {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.newsSeparator.cgColor
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }

        containerView.alpha = 0
    }
}

extension InsightNowViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        searchController?.search(textField.text ?? "")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleSearchMode(true)
    }
    
    /// <#Description#>
    /// - Parameter searchMode: <#searchMode description#>
    private func toggleSearchMode(_ searchMode: Bool) {
        if searchMode {
            addSearchController()
            searchBarTopConstraint.constant = 0
            searchBarTrailingConstraint.constant = 72
            searchBarHeightConstraint.constant = 50
            searchBar.layer.cornerRadius = 25
            xmarkButton.isHidden = false
            navigationLabel.isHidden = true
        } else{
            removeSearchController()
            searchBarTopConstraint.constant = 72
            searchBarTrailingConstraint.constant = 8
            searchBarHeightConstraint.constant = 60
            searchBar.layer.cornerRadius = 30
            searchField.text = ""
            xmarkButton.isHidden = true
            navigationLabel.isHidden = false
        }

        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = searchMode ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    /// <#Description#>
    private func addSearchController() {
        //
        if children.exclude(where: { $0 === searchController }),
           let searchCon = SearchViewController.instantiateViewController(from: "Search") {
            self.searchController = searchCon
            addChild(searchCon, to: containerView)
        }
    }
    
    /// <#Description#>
    private func removeSearchController() {
        if let searchController = searchController {
            removeChild(searchController)
        }
    }
}

extension InsightNowViewController: CircleButtonDelegate {

    func circleButton(
        _ button: CircleButton,
        didTappedButton imageName: String,
        for tag: Int
    ) {
        searchField.endEditing(true)
        toggleSearchMode(false)
    }
}
