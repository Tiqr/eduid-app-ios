//
//  EmailLoginCodeViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 08/05/2025.
//

import Foundation
import UIKit
import TinyConstraints
import Combine

protocol EmailLoginCodeTextFieldDelegate: AnyObject {
    func didPressBackspace(on textField: EmailLoginCodeTextFieldTextField)
}

class EmailLoginCodeTextFieldTextField: UITextField {
    weak var backspaceDelegate: EmailLoginCodeTextFieldDelegate?
    
    override func deleteBackward() {
        if text?.isEmpty ?? true {
            backspaceDelegate?.didPressBackspace(on: self)
        }
        super.deleteBackward()
    }
}

class EmailLoginCodeViewController: CreateEduIDBaseViewController {
    
    private enum ViewConstants {
        static let topAnchorConstant: CGFloat = 150
        static let sidePaddingConstant: CGFloat = 24
        static let numberOfFields = 6
        static let containerSpacing: CGFloat = 12
        static let containerCornerRadius: CGFloat = 8
        static let containerBorderWidth: CGFloat = 1.0
        static let textfieldContainerSize: CGSize = .init(width: 51, height: 51)
    }
    
    private var textFields: [EmailLoginCodeTextFieldTextField] = []
    private var textFieldContainers: [UIView] = []
    private var code: String {
        return textFields.compactMap { $0.text }.joined()
    }
    
    private let viewModel: EmailCodeViewModel
    weak var createEduIDViewControllerDelegate: CreateEduIDViewControllerDelegate?
    public static let registrationUrlUserDefaultsKey: String = "registrationUrl"
    
    init(viewModel: EmailCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.resendCodeSuccessClosure = { [weak self] in
            guard let self else { return }
            self.showAlert(title: "title", message: "message")
        }
        
        
        viewModel.resendCodeErrorClosure = { [weak self] title, message in
            guard let self else { return }
            self.showAlert(title: title, message: message)
        }
        
        viewModel.userCodeInPutSuccessClosure = { [weak self] url in
            guard let self else { return }
            DispatchQueue.main.async {
                UserDefaults.standard.set(url?.absoluteString, forKey: EmailLoginCodeViewController.registrationUrlUserDefaultsKey)
                self.createEduIDViewControllerDelegate?.createEduIDViewControllerShowNextScreen(viewController: self)
            }
        }
        viewModel.userCodeInPutErrorClosure = { [weak self] title, message in
            guard let self else { return }
            self.showAlert(title: title, message: message)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .emailLoginCodeScreen
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: .createEduIDDidReturnFromMagicLink, object: nil)
        setupUI()
    }
    
    
    private func setupUI() {
        view.subviews.forEach { $0.removeFromSuperview() }

        let spacer = UIView()
        let posterLabel = UILabel.posterTextLabel(text: L.MagicLink.Header.localization, size: 24)
        let description = UILabel.subtitleLabel(text: L.LoginCode.Info.localization.components(separatedBy: "<").first ?? "")
        let emailLabel = UILabel.subtitleLabel(text: viewModel.email ?? "", partBold: viewModel.email)

        let stackView = UIStackView(arrangedSubviews: [spacer,
                                                       posterLabel,
                                                       description,
                                                       emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.setCustomSpacing(0, after: description)
        view.addSubview(stackView)

        stackView.topToSuperview(offset: ViewConstants.topAnchorConstant)
        stackView.leadingToSuperview(offset: ViewConstants.sidePaddingConstant)
        stackView.trailingToSuperview(offset: ViewConstants.sidePaddingConstant)

        let codeContainer = UIView()
        codeContainer.backgroundColor = .clear
        stackView.addArrangedSubview(codeContainer)
        codeContainer.height(ViewConstants.textfieldContainerSize.height)
        codeContainer.centerXToSuperview()

        let codeStack = UIStackView()
        codeStack.axis = .horizontal
        codeStack.distribution = .fillEqually
        codeStack.spacing = ViewConstants.containerSpacing
        codeContainer.addSubview(codeStack)
        codeStack.edgesToSuperview()

        for i in 0..<ViewConstants.numberOfFields {
            let container = UIView()
            container.layer.cornerRadius = ViewConstants.containerCornerRadius
            container.layer.borderWidth = ViewConstants.containerBorderWidth
            container.layer.borderColor = UIColor.gray.cgColor
            codeStack.addArrangedSubview(container)
            container.width(ViewConstants.textfieldContainerSize.width)
            container.height(container.frame.width)
            
            let textField = EmailLoginCodeTextFieldTextField()
            textField.delegate = self
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 27)
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.autocapitalizationType = .allCharacters
            textField.borderStyle = .none
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.tag = i
            textField.backspaceDelegate = self

            container.addSubview(textField)
            textField.edgesToSuperview()
        }

        let resendLabel: EduIDLinkLabel = .init()
        resendLabel.set(normalText: L.LoginCode.Resend.localization,
                        linkText: L.LoginCode.ResendLink.localization) { [weak self] in
            guard let self else { return }
            self.resendAction()
        }
        stackView.addArrangedSubview(resendLabel)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }
        
        let currentIndex = textField.tag
        if text.count == 1 {
            if currentIndex < ViewConstants.numberOfFields - 1 {
                textFields[currentIndex + 1].becomeFirstResponder()
                highlightActiveField(index: currentIndex + 1)
            } else {
                if code.trimmingCharacters(in: .whitespaces).count >= 6 {
                    textField.resignFirstResponder()
                    viewModel.userCodeInPut(code)
                }
            }
        }
    }
    
    private func highlightActiveField(index: Int) {
        for (i, container) in textFieldContainers.enumerated() {
            let isActive = i == index
            container.layer.borderColor = isActive ? UIColor.systemBlue.cgColor : UIColor.gray.cgColor
            container.layer.shadowColor = isActive ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
            container.layer.shadowRadius = isActive ? 4 : 0
            container.layer.shadowOpacity = isActive ? 0.6 : 0
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    private func gestureRecognizerForResendTheCode() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resendAction))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        return gestureRecognizer
    }
    
    @objc private func resendAction() {
        viewModel.resendCode()
    }
}

extension EmailLoginCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.count <= 1
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        highlightActiveField(index: textField.tag)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isLastField = textField.tag == ViewConstants.numberOfFields - 1
        let allFilled = textFields.allSatisfy { ($0.text?.count ?? 0) == 1 }
        if isLastField && allFilled {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

extension EmailLoginCodeViewController {
    private func showAlert(title: String, message: String) {
        
    }
}

extension EmailLoginCodeViewController: EmailLoginCodeTextFieldDelegate {
    func didPressBackspace(on textField: EmailLoginCodeTextFieldTextField) {
        let currentIndex = textField.tag
        if currentIndex > 0 {
            let previous = textFields[currentIndex - 1]
            previous.text = ""
            previous.becomeFirstResponder()
            highlightActiveField(index: currentIndex - 1)
        }
    }
}
