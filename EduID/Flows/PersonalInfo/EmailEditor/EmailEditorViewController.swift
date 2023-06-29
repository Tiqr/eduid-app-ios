//
//  EmailEditorViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 12..
//

import Foundation
import UIKit
import TinyConstraints

class EmailEditorViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .personalInfoEditEmailScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: EmailEditorViewModel
    
    private var requestButton: UIButton!
    private var emailField: TextFieldViewWithValidationAndTitle!

    init(viewModel: EmailEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.setRequestButtonEnabled = { [weak self] isEnabled in
            guard let self = self else { return }
            self.requestButton.isEnabled = isEnabled
        }
        viewModel.hideKeyboard = { [weak self] in
            self?.resignKeyboardResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(isLoading: false)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidUpdateEmail), name: Notification.Name.didUpdateEmail, object: nil)
    }
    
    @objc
    func userDidUpdateEmail(_ notification: NSNotification) {
        // User updated the email.
        // First we confirm the URL via the API, then go back
        setupUI(isLoading: true)
        guard let url = notification.userInfo?[Constants.UserInfoKey.emailUpdateUrl] as? URL else {
            assertionFailure("Email update URL not found in notification object!")
            onUpdateFailed(nil)
            return
        }
        Task {
            do {
                if let result = try await viewModel.confirmEmailUpdate(url: url) {
                    delegate?.goBackToInfoScreen(updateData: true)
                } else {
                    onUpdateFailed(nil)
                }
            } catch {
                NSLog("Unable to confirm email update: \(error)")
                onUpdateFailed(error)
            }
        }
    }
    
    private func onUpdateFailed(_ error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setupUI(isLoading: false)
            let alert = UIAlertController(title: L.Generic.RequestError.Title.localization,
                                          message: L.Email.UpdateError(args: error?.localizedFromApi ?? "?").localization,
                                          preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
    
    private func setupUI(isLoading: Bool) {
        view.backgroundColor = .white
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
        let fullTitleString = "\(L.Email.Title.Edit.localization)\n\(L.Email.Title.EmailAddress.localization)"
        let mainTitle = UILabel.posterTextLabelBicolor(text: fullTitleString, size: 24, primary: L.Email.Title.EmailAddress.localization)
        let subTitle = UILabel.plainTextLabelPartlyBold(text: L.Email.Info.localization)
        let bottomSpacer = UIView()

        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            subTitle
        ])
        
        if isLoading {
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.width(40)
            loadingIndicator.height(40)
            loadingIndicator.startAnimating()
            topStackView.addArrangedSubview(loadingIndicator)
            topStackView.setCustomSpacing(8, after: loadingIndicator)
        } else {
            emailField = TextFieldViewWithValidationAndTitle(
                title: L.Email.NewEmail.localization,
                placeholder: L.Email.Placeholder.localization,
                field: .email,
                keyboardType: .emailAddress,
                isPassword: false
            )
            emailField.delegate = viewModel
            topStackView.addArrangedSubview(emailField)
        }
        bottomSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        topStackView.addArrangedSubview(bottomSpacer)
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.Email.Cancel.localization)
        requestButton = EduIDButton(type: .primary, buttonTitle: L.Email.Update.localization)
        requestButton.isEnabled = false
        
        
   
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 8
        topStackView.setCustomSpacing(16, after: mainTitle)
        topStackView.setCustomSpacing(24, after: subTitle)
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            cancelButton,
            requestButton
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(80))
        emailField.widthToSuperview()
        
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16))

        // Add click targets
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        requestButton.addTarget(self, action: #selector(requestEmailChange), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    @objc func resignKeyboardResponder() {
        _ = emailField.resignFirstResponder()
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc func requestEmailChange() {
        Task {
            do {
                let response = try await viewModel.changeEmail()
                // All went well, we need the user to confirm it now.
                delegate?.showConfirmEmailScreen(viewController: self, emailToVerify: viewModel.currentEmail)
            } catch {
                showError(error)
            }
            
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: L.Generic.RequestError.Title.localization,
            message: L.Email.UpdateError(args: error.localizedFromApi).localization,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }
}
