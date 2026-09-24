//
//  ChangeSMSRecoveryExplanationViewController.swift
//  eduID
//
//  Created by Copilot on 2026. 09. 03..
//

import Foundation
import UIKit
import TinyConstraints

class ChangeSMSRecoveryExplanationViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityChangeSMSRecoveryExplanation
    
    private let viewModel: ChangeSMSRecoveryExplanationViewModel
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    private let changeButton = EduIDButton(type: .primary, buttonTitle: L.ChangeSMSRecovery.Button.Change.localization)
    
    init(viewModel: ChangeSMSRecoveryExplanationViewModel) {
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
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
        let titleString = L.ChangeSMSRecovery.Title.localization
        let mainTitle = UILabel.posterTextLabelBicolor(text: titleString, size: 24, primary: titleString)
        
        let descriptionLabel = UILabel.plainTextLabelPartlyBold(text: L.ChangeSMSRecovery.Description.localization)
        
        let bottomSpacer = UIView()

        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            descriptionLabel,
            bottomSpacer
        ])
        
        bottomSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let backButton = EduIDButton(type: .ghost, buttonTitle: L.ChangeSMSRecovery.Button.Back.localization)
           
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            backButton,
            changeButton
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(24), usingSafeArea: true)
        
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16), usingSafeArea: true)

        // Add click targets
        backButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(startVerification), for: .touchUpInside)
    }
    
    @objc func startVerification() {
        // Prevent starting multiple challenges (e.g. on double tap) while one is already in progress
        guard changeButton.isEnabled else { return }
        changeButton.isEnabled = false
        viewModel.startAuthenticationChallenge { [weak self] success in
            DispatchQueue.main.async {
                guard let self else { return }
                guard success else {
                    self.showVerificationFailedDialog()
                    return
                }
                if self.viewModel.isBiometricVerificationAvailable {
                    self.viewModel.verifyWithBiometrics { [weak self] success in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            if success {
                                self.goToPhoneVerificationCodeScreen()
                            } else {
                                self.presentPinCodeVerifyScreen()
                            }
                        }
                    }
                } else {
                    self.presentPinCodeVerifyScreen()
                }
            }
        }
    }
    
    private func presentPinCodeVerifyScreen() {
        // The PIN screen can be cancelled without notifying us, so allow restarting the verification afterwards
        changeButton.isEnabled = true
        let pinCodeVC = VerifyPinCodeViewController()
        pinCodeVC.pinDelegate = self
        pinCodeVC.screenType = .pincodeScreen
        pinCodeVC.modalPresentationStyle = .fullScreen
        present(pinCodeVC, animated: true)
    }
    
    private func goToPhoneVerificationCodeScreen() {
        changeButton.isEnabled = true
        delegate?.goToChangeSMSRecoveryPhoneNumberScreen(viewController: self, personalInfo: viewModel.personalInfo)
    }
    
    private func showVerificationFailedDialog() {
        changeButton.isEnabled = true
        let alert = UIAlertController(
            title: L.Generic.RequestError.Title.localization,
            message: L.ChangeSMSRecovery.VerificationFailed.localization,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default))
        present(alert, animated: true)
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}

extension ChangeSMSRecoveryExplanationViewController: VerifyPinCodeDelegate {
    func get(pinCode: String) {
        changeButton.isEnabled = false
        viewModel.verifyWithPIN(pinCode) { [weak self] success in
            DispatchQueue.main.async {
                guard let self else { return }
                if success {
                    self.goToPhoneVerificationCodeScreen()
                } else {
                    self.showVerificationFailedDialog()
                }
            }
        }
    }
}
