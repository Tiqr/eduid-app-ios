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
    
    private enum ViewConstants {
        static let topAnchorConstant: CGFloat = 60
        static let sidePaddingConstant: CGFloat = 24
    }
    
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
        screenType = .checkMailScreen
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: .createEduIDDidReturnFromMagicLink, object: nil)
        setupUI()
    }
    
    
    private func setupUI() {
        
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let spacer: UIView = .init()
        let posterLabel = UILabel.posterTextLabel(text: L.MagicLink.Header.localization, size: 24)
        let description: UILabel = .subtitleLabel(text: "Enter the code sent to")
        let emailLabel: UILabel = .subtitleLabel(text: viewModel.email, partBold: viewModel.email)
        let stackView = UIStackView(arrangedSubviews: [spacer,
                                                       posterLabel,
                                                       description,
                                                       emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.setCustomSpacing(.zero, after: description)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewConstants.topAnchorConstant),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidePaddingConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ViewConstants.sidePaddingConstant)
        ])
    }
    
}
