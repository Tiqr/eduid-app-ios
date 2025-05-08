//
//  EmailCodeViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 08/05/2025.
//

import Foundation
import UIKit
import Combine

class EmailCodeViewController: CreateEduIDBaseViewController {
    
    private let viewModel: EmailCodeViewModel
    
    init(viewModel: EmailCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .emailCodeScreen
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    
}
