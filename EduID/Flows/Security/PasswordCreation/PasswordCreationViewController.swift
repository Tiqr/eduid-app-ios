//
//  PasswordCreationViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 22/08/2025.
//

import UIKit
import OpenAPIClient

class PasswordCreationViewController: CreateEduIDBaseViewController {
    
    private var viewModel: PasswordCreationViewModel
    
    private let changePassword: Bool
    
    private lazy var mainTitle: UILabel = {
        let title: String = changePassword ? L.ChangePassword.Title.ChangePassword.localization : L.ChangePassword.Title.AddPassword.localization
        return .posterTextLabelBicolor(text: title, size: 24, primary: title)
    }()
    
    private lazy var subTitle: UILabel = {
        let title: String = L.Password.PasswordDisclaimer.localization
        return .plainTextLabelPartlyBold(text: title)
    }()
    
    private lazy var firstPasswordField: TextFieldViewWithValidationAndTitle = {
        let field: TextFieldViewWithValidationAndTitle = .init(title: L.Password.NewPassword.localization, placeholder: "", field: .password, keyboardType: .default)
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .next
        return field
    }()
    
    private lazy var secondPasswordField: TextFieldViewWithValidationAndTitle = {
        let field: TextFieldViewWithValidationAndTitle = .init(title: L.Password.ConfirmPassword.localization, placeholder: "", field: .password, keyboardType: .default)
        field.textField.isSecureTextEntry = true
        field.textField.returnKeyType = .done
        return field
    }()
    
    private lazy var cancelButton: EduIDButton = {
        let button: EduIDButton = .init(type: .borderedGray, buttonTitle: L.YourVerifiedInformation.ConfirmRemoval.Button.Cancel.localization)
        button.addTarget(self, action: #selector(cancel), for: .allEvents)
        return button
    }()
    
    private lazy var setPasswordButton: EduIDButton = {
        let buttonTitle: String = changePassword ? L.Password.SetUpdate.localization : L.Password.ConfirmPassword.localization
        let button: EduIDButton = .init(type: .primary, buttonTitle: buttonTitle)
        button.addTarget(self, action: #selector(setNewPassword), for: .allEvents)
        return button
    }()
    
    private lazy var deletePasswordButton: UIView = {
        let button: UIView = .init()
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 6
        button.backgroundColor = .lightGray
        
        let imageFrame: CGRect = .init(origin: .zero, size: .init(width: 28, height: 28))
        let imageView: UIImageView = .init(frame: imageFrame)
        imageView.image = .bin.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .alertsRedColor
        
        button.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageView.frame.height),
            imageView.widthAnchor.constraint(equalToConstant: imageView.frame.width),
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(deletePassword))
        gesture.numberOfTapsRequired = 1
        button.addGestureRecognizer(gesture)
        
        
        return button
    }()
    
    init(viewModel: PasswordCreationViewModel, changePassword: Bool) {
        self.changePassword = changePassword
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.createPasswordSuccessClosure = { [weak self] in
            guard let self else { return }
            let message: String = changePassword ? L.Password.Updated.localization : L.Password.Set.localization
            showConfirmationAlert(with: message)
        }
        
        viewModel.deletePasswordSuccessClosure = { [weak self] in
            guard let self else { return }
            showConfirmationAlert(with: L.Password.Deleted.localization)
        }
        
        viewModel.errorClosure = { [weak self] title, message in
            guard let self else { return }
            self.showAlert(title: title, message: message, buttonTitle: L.PhoneVerification.Ok.localization)
        }
    }
    
    private func popBackToRoot() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.requesting = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let spacer: UIView = .init()
        let buttonsStackView: UIStackView = .init(arrangedSubviews: [cancelButton,
                                                                     setPasswordButton])
        if changePassword {
            buttonsStackView.spacing = 15
            buttonsStackView.insertArrangedSubview(deletePasswordButton, at: 0)
        } else {
            buttonsStackView.spacing = 25
        }
        
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
            setPasswordButton.widthAnchor.constraint(equalToConstant: 200),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            deletePasswordButton.widthAnchor.constraint(equalToConstant: 50),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
        
        firstPasswordField.textField.delegate = self
        secondPasswordField.textField.delegate = self
        
        addTapGestureToView()
    }
    
    private func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
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
    
    @objc private func deletePassword() {
        Task {
            await viewModel.deletePassword()
        }
    }
    
    override func goBack() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension PasswordCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstPasswordField.textField {
            secondPasswordField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension PasswordCreationViewController {
    func showConfirmationAlert(with message: String) {
        let alert: UIAlertController = .init(title: nil, message: message, preferredStyle: .alert)
        let alertAction: UIAlertAction = .init(title: L.PhoneVerification.Ok.localization, style: .default) { [weak self] _ in
            guard let self else { return }
            self.popBackToRoot()
        }
        alert.addAction(alertAction)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.present(alert, animated: true)
        }
    }
}
