//
//  VerifyWithIdVerificationCodeViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 13/02/2025.
//

import Foundation
import UIKit

protocol VerifyWithIdVerificationCodeViewControllerDelegate: AnyObject, NavigationDelegate {
    
}

class VerifyWithIdVerificationCodeViewController: BaseViewController {
    
    private var stack: UIStackView!
    
    weak var delegate: VerifyWithIdVerificationCodeViewControllerDelegate?
    
    // person
    var person: VerifyPerson
    
    //MARK: - init
    init(person: VerifyPerson) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .verifyWithIdVerificationCodeScreen
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    @objc private func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
}
