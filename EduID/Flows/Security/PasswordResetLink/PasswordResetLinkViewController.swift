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
    
    private var sendEmailButton: EduIDButton!
    private var loadingIndicator: UIActivityIndicatorView!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(userWillAddPassword), name: Notification.Name.willAddPassword, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userWillChangePassword), name: Notification.Name.willChangePassword, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func userWillAddPassword(_ notification: NSNotification) {
        // User wants to add a password
        guard let url = notification.userInfo?[Constants.UserInfoKey.passwordChangeUrl] as? URL else {
            assertionFailure("Password add URL not found in notification object!")
            return
        }
        delegate?.goToChangePasswordFlow(viewController: self, changeOrAddUrl: url, isForAdd: true)
    }
    
    @objc
    func userWillChangePassword(_ notification: NSNotification) {
        // User wants to add a password
        guard let url = notification.userInfo?[Constants.UserInfoKey.passwordChangeUrl] as? URL else {
            assertionFailure("Password add URL not found in notification object!")
            return
        }
        delegate?.goToChangePasswordFlow(viewController: self, changeOrAddUrl: url, isForAdd: false)
    }
    
    private func setupUI() {
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
        let titleString: String
        let subtitleString: String
        if viewModel.personalInfo.usePassword == true {
            titleString = L.PasswordResetLink.Title.ChangePassword.localization
            subtitleString = L.PasswordResetLink.Description.ChangePassword.localization
        } else {
            titleString = L.PasswordResetLink.Title.AddPassword.localization
            subtitleString = L.PasswordResetLink.Description.AddPassword.localization
        }
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: titleString, size: 24, primary: titleString)
        let subTitle = UILabel.plainTextLabelPartlyBold(text: subtitleString)
        let bottomSpacer = UIView()

        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            subTitle
        ])
        
        bottomSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        topStackView.addArrangedSubview(bottomSpacer)
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.PasswordResetLink.Button.Cancel.localization)
        sendEmailButton = EduIDButton(type: .primary, buttonTitle: L.PasswordResetLink.Button.SendEmail.localization)
        
        let sendEmailContainer = UIView()
        sendEmailContainer.addSubview(sendEmailButton)
        sendEmailButton.edgesToSuperview()
        
        loadingIndicator = UIActivityIndicatorView()
        sendEmailContainer.addSubview(loadingIndicator)
        loadingIndicator.heightToSuperview()
        loadingIndicator.widthToHeight(of: loadingIndicator)
        loadingIndicator.centerXToSuperview(offset: 70)
        loadingIndicator.isHidden = true
   
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 8
        topStackView.setCustomSpacing(16, after: mainTitle)
        topStackView.setCustomSpacing(24, after: subTitle)
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            cancelButton,
            sendEmailContainer
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(80))
        
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16))

        // Add click targets
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        sendEmailButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc func sendEmail() {
        Task {
            sendEmailButton.isEnabled = false
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            do {
                _ = try await viewModel.requestPasswordResetLink()
                delegate?.goToCheckEmail(viewController: self, email: viewModel.personalInfo.email)
            } catch {
                let alert = UIAlertController(
                    title: L.Generic.RequestError.Title.localization,
                    message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self.present(alert, animated: true)
                sendEmailButton.isEnabled = true
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimating()
            }

        }
    }
}
