//
//  EmailLoginCodeViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 08/05/2025.
//

import Foundation
import UIKit
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
        static let topAnchorConstant: CGFloat = 60
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
            
        }
        
        
        viewModel.resendCodeErrorClosure = { [weak self] title, message in
            guard let self else { return }
        }
        
        viewModel.userCodeInPutSuccessClosure = { [weak self] url in
            guard let self else { return }
            DispatchQueue.main.async {
                if let navigationController = self.navigationController {
                    UserDefaults.standard.set(url?.absoluteString, forKey: EmailLoginCodeViewController.registrationUrlUserDefaultsKey)
                    self.createEduIDViewControllerDelegate?.createEduIDViewControllerShowNextScreen(viewController: self)
                }
            }
        }
        viewModel.userCodeInPutErrorClosure = { [weak self] title, message in
            guard let self else { return }
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
        
        let spacer: UIView = .init()
        let posterLabel = UILabel.posterTextLabel(text: L.MagicLink.Header.localization, size: 24)
        let description: UILabel = .subtitleLabel(text: L.LoginCode.Info.localization.components(separatedBy: "<").first ?? "")
        let emailLabel: UILabel = .subtitleLabel(text: viewModel.email ?? "", partBold: viewModel.email)
        
        let stackView = UIStackView(arrangedSubviews: [spacer,
                                                       posterLabel,
                                                       description,
                                                       emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.setCustomSpacing(.zero, after: description)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Code stack view with containers
        let codeStackViewContainerView = UIView()
        codeStackViewContainerView.backgroundColor = .clear
        codeStackViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let codeStackView: UIStackView = .init(frame: .init(origin: .zero, size: ViewConstants.textfieldContainerSize))
        codeStackView.axis = .horizontal
        codeStackView.spacing = ViewConstants.containerSpacing
        codeStackView.distribution = .fillEqually
        codeStackView.alignment = .center
        codeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<ViewConstants.numberOfFields {
            // Container setup
            let container = UIView()
            container.layer.cornerRadius = ViewConstants.containerCornerRadius
            container.layer.borderWidth = ViewConstants.containerBorderWidth
            container.layer.borderColor = UIColor.gray.cgColor
            container.translatesAutoresizingMaskIntoConstraints = false
            container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
            
            // Text field setup
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
            
            // Add text field to container
            container.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.widthAnchor.constraint(equalToConstant: ViewConstants.textfieldContainerSize.width),
                container.heightAnchor.constraint(equalToConstant: ViewConstants.textfieldContainerSize.height),
                textField.topAnchor.constraint(equalTo: container.topAnchor),
                textField.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
            
            codeStackView.addArrangedSubview(container)
            textFieldContainers.append(container)
            textFields.append(textField)
        }
        
        // Resend code labels
        let resendContainerView = UIView()
        resendContainerView.translatesAutoresizingMaskIntoConstraints = false

        let problemsLabel = UILabel()
        problemsLabel.text = L.LoginCode.Resend.localization
        problemsLabel.font = UIFont.sourceSansProRegular(size: 16)
        problemsLabel.textColor = UIColor.darkGray

        let resendTheCode = UILabel()
        resendTheCode.attributedText = NSAttributedString(
            string: L.LoginCode.ResendLink.localization,
            attributes: [
                .font: UIFont.sourceSansProRegular(size: 16),
                .foregroundColor: UIColor.backgroundColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.backgroundColor
            ]
        )
        resendTheCode.isUserInteractionEnabled = true
        resendTheCode.addGestureRecognizer(gestureRecognizerForResendTheCode())

        let resendStackView = UIStackView(arrangedSubviews: [problemsLabel, resendTheCode])
        resendStackView.axis = .horizontal
        resendStackView.alignment = .center
        resendStackView.spacing = 2
        resendStackView.translatesAutoresizingMaskIntoConstraints = false
        
        resendContainerView.addSubview(resendStackView)
        codeStackViewContainerView.addSubview(codeStackView)
        stackView.addArrangedSubview(codeStackViewContainerView)
        stackView.addArrangedSubview(resendContainerView)
        
        NSLayoutConstraint.activate([
            resendStackView.centerXAnchor.constraint(equalTo: resendContainerView.centerXAnchor),
            resendStackView.centerYAnchor.constraint(equalTo: resendContainerView.centerYAnchor),
            codeStackViewContainerView.heightAnchor.constraint(equalToConstant: ViewConstants.textfieldContainerSize.height),
            resendContainerView.heightAnchor.constraint(equalToConstant: 30),
            codeStackViewContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            codeStackView.centerXAnchor.constraint(equalTo: codeStackViewContainerView.centerXAnchor),
            resendContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewConstants.topAnchorConstant),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidePaddingConstant),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidePaddingConstant)
        ])
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
    
    // Resend code related
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
