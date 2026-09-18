//
//  DeletePasskeyConfirmationViewController.swift
//  eduID
//
//  Created by Copilot on 2026. 09. 03..
//

import Foundation
import UIKit
import TinyConstraints

class DeletePasskeyConfirmationViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityDeletePasskeyConfirmation
    
    private let viewModel: DeletePasskeyConfirmationViewModel
    
    private var cancelButton: EduIDButton!
    private var confirmButton: EduIDButton!
    private var loadingIndicator: UIActivityIndicatorView!
        
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    init(viewModel: DeletePasskeyConfirmationViewModel) {
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
        
        let titleString = L.ConfirmDeletePasskey.Title.localization
        let mainTitle = UILabel.posterTextLabelBicolor(text: titleString, size: 24, primary: titleString)
        
        let disclaimerContainer = UIView()
        let disclaimerLabel = UILabel()
        let warningImage = UIImageView()
        warningImage.image = .warning
        warningImage.size(CGSize(width: 22.5, height: 21))
        let disclaimerString = NSMutableAttributedString(
            string: L.ConfirmDeletePasskey.Subtitle.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        disclaimerContainer.addSubview(disclaimerLabel)
        disclaimerContainer.addSubview(warningImage)
        warningImage.leftToSuperview(offset: 12)
        warningImage.topToSuperview(offset: 12)
        disclaimerLabel.attributedText = disclaimerString
        disclaimerLabel.leftToRight(of: warningImage, offset: 12)
        disclaimerLabel.rightToSuperview(offset: -12)
        disclaimerLabel.verticalToSuperview(insets: .vertical(12))
        disclaimerLabel.numberOfLines = 0
        disclaimerContainer.backgroundColor = UIColor.alertsBackgroundColor
        
        let descriptionLabel = UILabel.plainTextLabelPartlyBold(
            text: L.ConfirmDeletePasskey.Description(args: viewModel.passkey.name ?? "?").localization
        )
        
        let bottomSpacer = UIView()

        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            disclaimerContainer,
            descriptionLabel,
            bottomSpacer
        ])
        
        disclaimerContainer.widthToSuperview()
        bottomSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        topStackView.addArrangedSubview(bottomSpacer)
        
        cancelButton = EduIDButton(type: .ghost, buttonTitle: L.ConfirmDeletePasskey.Button.Cancel.localization)
        confirmButton = EduIDButton(type: .filledRed, buttonTitle: L.ConfirmDeletePasskey.Button.Confirm.localization)
           
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        let confirmButtonContainer = UIView()
        confirmButtonContainer.addSubview(confirmButton)
        confirmButton.edgesToSuperview()
        
        loadingIndicator = UIActivityIndicatorView()
        confirmButtonContainer.addSubview(loadingIndicator)
        loadingIndicator.heightToSuperview()
        loadingIndicator.widthToHeight(of: loadingIndicator)
        loadingIndicator.centerXToSuperview()
        loadingIndicator.isHidden = true
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            cancelButton,
            confirmButtonContainer
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(24), usingSafeArea: true)
        
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16), usingSafeArea: true)

        // Add click targets
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(removeAndGoBack), for: .touchUpInside)
    }
    
    @objc func removeAndGoBack() {
        Task {
            cancelButton.isEnabled = false
            confirmButton.isEnabled = false
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            do {
                let personalInfo = try await viewModel.removePasskey()
                delegate?.goBackAfterRemovingPasskey(personalInfo)
            } catch {
                let alert = UIAlertController(
                    title: L.Generic.RequestError.Title.localization,
                    message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self.present(alert, animated: true)
                cancelButton.isEnabled = true
                confirmButton.isEnabled = true
                loadingIndicator.isHidden = true
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
