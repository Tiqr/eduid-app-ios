//
//  PasswordCreationViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 22/08/2025.
//

import UIKit
import OpenAPIClient

class PasswordCreationViewController: UIViewController {
    
    private var viewModel: PasswordCreationViewModel
    
    private lazy var mainTitle: UILabel = {
        let title: String = L.ChangePassword.Title.AddPassword.localization
        return .posterTextLabelBicolor(text: title, size: 24, primary: title)
    }()
    
    private lazy var subTitle: UILabel = {
        let title: String = L.Password.PasswordDisclaimer.localization
        return .plainTextLabelPartlyBold(text: title)
    }()
    
    private lazy var firstPasswordField: TextFieldViewWithValidationAndTitle = {
        let field: TextFieldViewWithValidationAndTitle = .init(title: L.Password.NewPassword.localization, placeholder: "", field: .password, keyboardType: .default)
        field.textField.isSecureTextEntry = true
        return field
    }()
    
    private lazy var secondPasswordField: TextFieldViewWithValidationAndTitle = {
        let field: TextFieldViewWithValidationAndTitle = .init(title: L.Password.ConfirmPassword.localization, placeholder: "", field: .password, keyboardType: .default)
        field.textField.isSecureTextEntry = true
        return field
    }()
    
    private lazy var cancelButton: EduIDButton = {
        let button: EduIDButton = .init(type: .borderedGray, buttonTitle: L.YourVerifiedInformation.ConfirmRemoval.Button.Cancel.localization)
        button.addTarget(self, action: #selector(cancel), for: .allEvents)
        return button
    }()
    
    private lazy var setPasswordButton: EduIDButton = {
        let button: EduIDButton = .init(type: .primary, buttonTitle: L.Password.SetUpdate.localization)
        button.addTarget(self, action: #selector(setNewPassword), for: .allEvents)
        return button
    }()
    
    init(viewModel: PasswordCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.successClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        viewModel.errorClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message, buttonTitle: L.PhoneVerification.Ok.localization)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let buttonSpacer: UIView = .init()
        let spacer: UIView = .init()
        let buttonsStackView: UIStackView = .init(arrangedSubviews: [cancelButton,
                                                                     buttonSpacer ,
                                                                     setPasswordButton])
        buttonsStackView.axis = .horizontal
        
        let mainStackView: UIStackView = .init(arrangedSubviews: [mainTitle,
                                                              subTitle,
                                                              firstPasswordField,
                                                              secondPasswordField,
                                                              spacer,
                                                              buttonsStackView
                                                             ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setPasswordButton.widthAnchor.constraint(equalToConstant: 180),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
        
    }
    
    
    @objc func setNewPassword() {
        guard firstPasswordField.textField.text == secondPasswordField.textField.text else {
            showAlert(title: "", message: L.ChangePassword.Label.MismatchError.localization, buttonTitle: L.PhoneVerification.Ok.localization)
            return
        }
        guard
            let password = firstPasswordField.textField.text,
            (password.count >= 15 || (password.count >= 8 && password.range(of: "[A-Z]", options: .regularExpression) != nil && password.range(of: "\\d", options: .regularExpression) != nil))
        else {
            showAlert(title: "", message: L.RegEXError.Password.localization, buttonTitle: L.PhoneVerification.Ok.localization)
            return
        }
        
        Task {
            await viewModel.createPassword(with: password)
        }
    }
    
    @objc func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default))
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
