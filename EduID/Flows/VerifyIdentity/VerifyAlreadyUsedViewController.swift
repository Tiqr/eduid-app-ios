//
//  VerifyAlreadyUsedViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 03/04/2025.
//

import UIKit

final class VerifyAlreadyUsedViewController: BaseViewController {
    
    var email: String
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        screenType = .verifyAlreadyUsedScreen
    }
    
    
    private func setupUI() {
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let mainTitle: UILabel = UILabel.posterTextLabelBicolor(
            text: L.EppnAlreadyLinked.Title.VerificationFailed.localization,
            size: 24,
            primary: L.EppnAlreadyLinked.Title.VerificationFailed.localization
        )
        let description = UILabel.subtitleLabel(text: L.EppnAlreadyLinked.InfoExternalAccountWithEmail(args: "\n\(email)").localization)
        let spacer: UIView = .init()
        
        let continueButton: EduIDButton = .init(type: .primary, buttonTitle: L.LinkingSuccess.Button.Continue.localization)
        continueButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        let vStack: UIStackView = .init(arrangedSubviews: [mainTitle,
                                                           description,
                                                           spacer,
                                                           continueButton])
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.distribution = .fill
        
        view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            vStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem)
        
    }
    
    @objc private func dismissAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
