//
//  NameEditorViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import UIKit
import TinyConstraints

class NameEditorViewController : UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .personalInfoNameEditorScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: NameEditorViewModel
    
    private var firstNameField: TextFieldViewWithValidationAndTitle!
    private var lastNameField: TextFieldViewWithValidationAndTitle!
    private var saveButton: EduIDButton!

    init(viewModel: NameEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(isLoading: false)
        
        viewModel.hideKeyboard = { [weak self] in
            self?.resignKeyboardResponder()
        }
        viewModel.setSaveButtonEnabled = { [weak self] enabled in
            self?.saveButton.isEnabled = enabled
        }
    }
    
    private func setupUI(isLoading: Bool) {
        view.backgroundColor = .white
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        let fullTitleString = "\(L.EditName.Title.Edit.localization)\n\(L.EditName.Title.YourName.localization)"
        let mainTitle = UILabel.posterTextLabelBicolor(text: fullTitleString, size: 24, primary: L.EditName.Title.YourName.localization)
        
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle
        ])
        
        if (isLoading) {
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.width(40)
            loadingIndicator.height(40)
            loadingIndicator.startAnimating()
            topStackView.addArrangedSubview(loadingIndicator)
            loadingIndicator.horizontalToSuperview()
        } else {
            firstNameField = TextFieldViewWithValidationAndTitle(
                title: L.EditName.FirstName.localization,
                placeholder: "",
                field: .name,
                keyboardType: .namePhonePad,
                isPassword: false
            )
            firstNameField.textField.text = viewModel.currentFirstName
            firstNameField.tag = NameEditorViewModel.TAG_FIRST_NAME
            firstNameField.delegate = viewModel
            
            lastNameField = TextFieldViewWithValidationAndTitle(
                title: L.EditName.LastName.localization,
                placeholder: "",
                field: .name,
                keyboardType: .namePhonePad,
                isPassword: false
            )
            lastNameField.textField.text = viewModel.currentLastName
            lastNameField.tag = NameEditorViewModel.TAG_LAST_NAME
            lastNameField.delegate = viewModel
            
            topStackView.addArrangedSubview(firstNameField)
            topStackView.addArrangedSubview(lastNameField)
            
            firstNameField.widthToSuperview()
            lastNameField.widthToSuperview()
        }

        let bottomSpacer = UIView()
        topStackView.addArrangedSubview(bottomSpacer)
        
        scrollView.addSubview(topStackView)
        topStackView.width(to: scrollView, offset: -48)
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(24))

        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.EditName.Button.Cancel.localization)
        saveButton = EduIDButton(type: .primary, buttonTitle: L.EditName.Button.Save.localization)
        saveButton.isEnabled = !isLoading
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 30
        topStackView.setCustomSpacing(20, after: firstNameField)
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            cancelButton,
            saveButton
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(bottomStackView)
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16), usingSafeArea: true)

        // Add click targets
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveNameChange), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }

    @objc func saveNameChange() {
        Task {
            guard let firstName = firstNameField.textField.text,
                  let lastName = lastNameField.textField.text else {
                return
            }
            setupUI(isLoading: true)
            do {
                _ = try await viewModel.saveNameChange(firstName: firstName, lastName: lastName)
                delegate?.goBackToInfoScreen(updateData: true)
            } catch {
                NSLog("Unable to update name of the user: \(error)")
                showError(error: error)
                setupUI(isLoading: false)
            }
        }
            
    }
    
    private func showError(error: Error) {
        let alert = UIAlertController(
            title: L.Generic.RequestError.Title.localization,
            message: L.Generic.RequestError.Description(args: error.localizedFromApi).localization,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc func onContinueClicked() {
        delegate?.goBack(viewController: self)
    }
    
    
    @objc func resignKeyboardResponder() {
        _ = firstNameField.resignFirstResponder()
        _ = lastNameField.resignFirstResponder()
    }
}
