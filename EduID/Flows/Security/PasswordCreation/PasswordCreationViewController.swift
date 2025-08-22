//
//  PasswordCreationViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 22/08/2025.
//

import UIKit
import TinyConstraints
import OpenAPIClient

class PasswordCreationViewController: UIViewController {
    
    private var viewModel: PasswordCreationViewModel
    
    init(viewModel: PasswordCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .blue
    }
    
}
