//
//  PasswordResetLinkViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 16..
//

import Foundation
import UIKit
import TinyConstraints

class PasswordResetLinkViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityPasswordResetLinkScreen
    
    private let viewModel: PasswordResetLinkViewModel
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    init(viewModel: PasswordResetLinkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // TODO
    }
    
    
}
