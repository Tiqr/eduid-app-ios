//
//  SelectYourBankViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 30/09/2024.
//
import UIKit
import TinyConstraints

class SelectYourBankViewController: BaseViewController {
    
    var delegate: PersonalInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .selectYourBank
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    func setupUI() {
        // TODO
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
