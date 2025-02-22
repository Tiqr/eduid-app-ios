//
//  VerifyWithIdInputViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 13/02/2025.
//

import UIKit
import TinyConstraints
import OpenAPIClient
import Combine

protocol VerifyWithIdInputViewControllerDelegate: AnyObject, NavigationDelegate, PersonalInfoViewControllerDelegate {
    func goToVerifyWithIdInputScreen(viewController: UIViewController, controlCode: ControlCode?)
    func goToVerifyWithIdVerificationCodeScreen(viewController: UIViewController, person: VerifyPerson, controlCode: ControlCode?)
}

protocol VerifyWithIdVerificationCodeDelegate: AnyObject {
    func send(person: VerifyPerson, controlCode: ControlCode?)
}

class VerifyWithIdInputViewController: BaseViewController {
    
    private enum ViewConstants {
        static let idImageName: String = "VerifyIDImage"
        enum FieldTag: Int {
            case lastName = 100000001
            case firstName = 100000002
            case dateOfBirth = 100000003
        }
    }
    
    //- viewmodel
    private var viewModel: VerifyWithIdInputViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private var stack: UIStackView!
    weak var delegate: VerifyWithIdInputViewControllerDelegate?
    weak var verifyWithIdVerificationCodeDelegate: VerifyWithIdVerificationCodeDelegate?
    
    // - scroll view
    private let scrollView = UIScrollView()
    
    // - keyboard related
    private var isKeyBoardOnScreen = false
    private var keyboardHeight: CGFloat?
    
    var validationMap: [Int: Bool] = [ViewConstants.FieldTag.lastName.rawValue: false,
                                      ViewConstants.FieldTag.firstName.rawValue: false,
                                      ViewConstants.FieldTag.dateOfBirth.rawValue: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            setVerificationCodeButtonEnabled(state: isTrue)
        }
    }
    
    // MARK: TextFields
    private let lastNameTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdInput.InputField.LastName.localization,
                                                                   placeholder: "", field: .name,
                                                                   keyboardType: .alphabet,
                                                                   showNextInsteadOfReturn: true)
        textField.tag = ViewConstants.FieldTag.lastName.rawValue
        return textField
    }()
    
    private let firstNameTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdInput.InputField.FirstNames.localization,
                                                                   placeholder: "",
                                                                   field: .name,
                                                                   keyboardType: .alphabet,
                                                                   showNextInsteadOfReturn: true)
        textField.tag = ViewConstants.FieldTag.firstName.rawValue
        return textField
    }()
    
    private let dateOfBirthTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdInput.InputField.DateOfBirth.localization,
                                                                   placeholder: "",
                                                                   field: .name,
                                                                   keyboardType: .alphabet)
        textField.tag = ViewConstants.FieldTag.dateOfBirth.rawValue
        return textField
    }()
    
    // - generate verification code button
    private let generateVerificationCodeButton: EduIDButton = {
        let button: EduIDButton = .init(type: .primary, buttonTitle: L.ConfirmIdentityWithIdInput.GenerateVerificationCodeButton.localization)
        button.isEnabled = false
        return button
    }()
    
    //MARK: - init
    init(viewModel: VerifyWithIdInputViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .verifyWithIdInputScreen
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupCombine()
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //// - setup combine
    private func setupCombine() {
        viewModel.controlCodePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] controlCode in
                guard let self else { return }
                if let person = viewModel.person {
                    if viewModel.viewShouldPop {
                        verifyWithIdVerificationCodeDelegate?.send(person: person, controlCode: controlCode)
                        navigationController?.popViewController(animated: true)
                    } else {
                        delegate?.goToVerifyWithIdVerificationCodeScreen(viewController: self, person: person, controlCode: controlCode)
                    }
                }
            }.store(in: &cancellable)
    }

    
    private func setupUI() {
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        // - set textfield values
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        
        generateVerificationCodeButton.addTarget(self, action: #selector(onEnterDetailsButtonTapped), for: .touchUpInside)
        
        //- setup textfields if view model has person data
        lastNameTextField.textField.text = viewModel.person?.lastName ?? viewModel.placeHolder.lastName
        firstNameTextField.textField.text = viewModel.person?.firstName ?? viewModel.placeHolder.firstName
        dateOfBirthTextField.textField.text = viewModel.person?.dateOfBirth ?? viewModel.placeHolder.dateOfBirth
        
        // - scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        let mainTitleFirstLine: String = L.ConfirmIdentityWithIdInput.Title.FirstLine.localization
        let mainTitleSecondLine: String = L.ConfirmIdentityWithIdInput.Title.SecondLine.localization
        let mainTitleSting: String = "\(mainTitleFirstLine)\n\(mainTitleSecondLine)"
        
        let mainTitle: UILabel = UILabel.posterTextLabelBicolor(
            text: mainTitleSting,
            size: 24,
            primary: mainTitleFirstLine
        )
        
        let mainDescription = UILabel.subtitleLabel(text: L.ConfirmIdentityWithIdInput.Explanation.localization)
        
        // - verify id image
        let imageView: UIImageView = .init(image: .init(named: ViewConstants.idImageName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        
        // - textField stack view
        let textFieldStack: UIStackView = .init(arrangedSubviews: [lastNameTextField,
                                                                   firstNameTextField,
                                                                   dateOfBirthTextField])
        textFieldStack.axis = .vertical
        textFieldStack.alignment = .center
        textFieldStack.distribution = .fill
        textFieldStack.spacing = .zero
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle,
                                               imageView,
                                               mainDescription,
                                               textFieldStack,
                                               generateVerificationCodeButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 30
        scrollView.addSubview(stack)

        // - setup constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: .zero, right: 0))
        stack.width(to: scrollView, offset: 0)
        mainTitle.widthToSuperview(offset: -48)
        mainDescription.widthToSuperview(offset: -48)
        imageView.widthToSuperview(offset: -48)
        imageView.height(200)
        textFieldStack.widthToSuperview(offset: -48)
        lastNameTextField.widthToSuperview()
        firstNameTextField.widthToSuperview()
        dateOfBirthTextField.widthToSuperview()
        generateVerificationCodeButton.widthToSuperview(offset: -48)
        generateVerificationCodeButton.bottom(to: scrollView, offset: view.safeAreaInsets.bottom)
        
    }
    
    @objc private func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc private func onEnterDetailsButtonTapped() {
        if let lastName = lastNameTextField.textField.text,
           let firstName = firstNameTextField.textField.text,
           let dateOfBirth = dateOfBirthTextField.textField.text {
            viewModel.person = .init(lastName: lastName, firstName: firstName, dateOfBirth: dateOfBirth)
            Task {
                await viewModel.createVerificationCode()
            }
        }
        
    }
}

// MARK: ValidatedTextFieldDelegate
extension VerifyWithIdInputViewController: ValidatedTextFieldDelegate {
    
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        validationMap[tag] = isValid
    }
    
    func keyBoardDidReturn(tag: Int) {
        switch tag {
        case ViewConstants.FieldTag.lastName.rawValue:
            _ = firstNameTextField.becomeFirstResponder()
        case ViewConstants.FieldTag.firstName.rawValue:
            _ = dateOfBirthTextField.becomeFirstResponder()
        case ViewConstants.FieldTag.dateOfBirth.rawValue:
            _ = dateOfBirthTextField.resignFirstResponder()
        default: break
        }
    }
    
    func didBecomeFirstResponder(tag: Int) {
        switch tag {
        case ViewConstants.FieldTag.lastName.rawValue:
            break
            
        case ViewConstants.FieldTag.firstName.rawValue:
            break
            
        case ViewConstants.FieldTag.dateOfBirth.rawValue:
            break
        default: break
        }
    }
}

// MARK: Keyboard presentation
extension VerifyWithIdInputViewController {
    @objc private func keyboardFrameChanged(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = keyboardFrame.size.height
        guard isKeyBoardOnScreen else { return }
        scrollView.contentInset.bottom = keyboardHeight ?? 0 + scrollView.safeAreaInsets.bottom
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        isKeyBoardOnScreen = true
        keyboardFrameChanged(notification: notification)
    }
    
    @objc private func keyboardDidHide() {
        isKeyBoardOnScreen = false
        resetScrollviewInsets()
    }
    
    private func resetScrollviewInsets() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.scrollView.contentInset.bottom = 0
            self.scrollView.contentOffset.y = -(self.view.safeAreaInsets.top)
        }
    }
    
    private func setVerificationCodeButtonEnabled(state: Bool) {
        generateVerificationCodeButton.isEnabled = state
    }
}
