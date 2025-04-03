//
//  VerifyAlreadyUsedViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 03/04/2025.
//

import UIKit
import TinyConstraints

protocol VerifyAlreadyUsedViewControllerDelegate: AnyObject, NavigationDelegate {
}


final class VerifyAlreadyUsedViewController: BaseViewController {
    
    weak var delegate: VerifyAlreadyUsedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .verifyAlreadyUsedScreen
        view.backgroundColor = .systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
    }
    
    @objc private func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
