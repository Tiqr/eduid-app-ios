//
//  ConfirmDeleteViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import UIKit
import TinyConstraints

class ConfirmDeleteViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .confirmDeleteAccountScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: ConfirmDeleteViewModel
    
    private var confirmButton: EduIDButton!
    private var nameField: TextFieldViewWithValidationAndTitle!
    
    init(viewModel: ConfirmDeleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.hideKeyboard = { [weak self] in
            self?.resignKeyboardResponder()
        }
        viewModel.setConfirmButtonEnabled = { [weak self] enabled in
            self?.confirmButton.isEnabled = enabled
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(isLoading: false)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    private func setupUI(isLoading: Bool) {
        view.backgroundColor = .white
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.ConfirmDelete.Title.localization, size: 24, primary: L.ConfirmDelete.Title.localization)
                

        let disclaimerContainer = UIView()
        let disclaimerLabel = UILabel()
        let errorImage = UIImageView()
        errorImage.image = .error
        errorImage.size(CGSize(width: 22.5, height: 21))
        let disclaimerString = NSMutableAttributedString(
            string: L.ConfirmDelete.Disclaimer.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        disclaimerLabel.attributedText = disclaimerString
        disclaimerContainer.addSubview(disclaimerLabel)
        disclaimerContainer.addSubview(errorImage)
        errorImage.leftToSuperview(offset: 12)
        errorImage.topToSuperview(offset: 18)
        disclaimerLabel.leftToRight(of: errorImage, offset: 12)
        disclaimerLabel.rightToSuperview(offset: -12)
        disclaimerLabel.verticalToSuperview(insets: .vertical(12))
        disclaimerLabel.numberOfLines = 0
        disclaimerContainer.backgroundColor = UIColor.alertsBackgroundColor
        
        let typeToConfirmLabel = UILabel()
        let typeToConfirm = NSMutableAttributedString(
            string: L.ConfirmDelete.TypeNameToConfirm.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        typeToConfirmLabel.numberOfLines = 0
        typeToConfirmLabel.attributedText = typeToConfirm
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            disclaimerContainer,
            typeToConfirmLabel
        ])
        
        if isLoading {
            let loadingIndicator = UIActivityIndicatorView()
            topStackView.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.widthToSuperview()
            loadingIndicator.startAnimating()
        } else {
            nameField = TextFieldViewWithValidationAndTitle(
                title: L.ConfirmDelete.YourFullNameLabel.localization,
                placeholder: L.ConfirmDelete.Placeholder.localization,
                field: .name,
                keyboardType: .namePhonePad,
                isPassword: false
            )
            nameField.delegate = viewModel
            nameField.textField.text = viewModel.currentFullName
            topStackView.addArrangedSubview(nameField)
            nameField.widthToSuperview()
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        confirmButton = EduIDButton(type: .filledRed, buttonTitle: L.ConfirmDelete.Button.Confirm.localization)
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.ConfirmDelete.Button.Cancel.localization)
        confirmButton.isEnabled = false
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [
            cancelButton, confirmButton
        ])
        
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.distribution = .fillEqually
        
        topStackView.addArrangedSubview(spacer)
        topStackView.addArrangedSubview(bottomButtonStack)
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 16
        
        mainTitle.widthToSuperview()
        disclaimerContainer.widthToSuperview()
        typeToConfirmLabel.widthToSuperview()
        spacer.widthToSuperview()
        bottomButtonStack.widthToSuperview()
        
        view.addSubview(topStackView)
        topStackView.edges(to: view, insets: TinyEdgeInsets(top: 72, left: 24, bottom: 24, right: 24))
        confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
    }
    
    
    @objc func confirmClicked() {
        if let error = viewModel.checkIfNameMatches() {
            let alert = UIAlertController(
                title: L.ConfirmDelete.NameDoesNotMatchError.Title.localization,
                message: error.localizedDescription,
                preferredStyle: .alert)
            alert.addAction(.init(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { _ in
                alert.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        } else {
            setupUI(isLoading: true)
            Task {
                do {
                    let response = try await viewModel.confirmDelete()
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.deleteStateAndGoToHome()
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        let alert = UIAlertController(
                            title: L.ConfirmDelete.DeleteError.Title.localization,
                            message: error.localizedDescription,
                            preferredStyle: .alert)
                        alert.addAction(.init(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { _ in
                            alert.dismiss(animated: true)
                        })
                        self?.present(alert, animated: true)
                        self?.setupUI(isLoading: false)
                    }
                }
            }
        }
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc func resignKeyboardResponder() {
        _ = nameField.resignFirstResponder()
    }
    
}
