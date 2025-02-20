//
//  VerifyWithIdVerificationCodeViewController.swift
//  eduID
//
//  Created by Yasser Farahi on 13/02/2025.
//

import UIKit
import TinyConstraints

protocol VerifyWithIdVerificationCodeViewControllerDelegate: AnyObject, NavigationDelegate {
}

class VerifyWithIdVerificationCodeViewController: BaseViewController {
    
    private enum ViewConstants {
        static let idImageName: String = "VerifyIDImage"
        enum FieldTag: Int {
            case lastName = 100000001
            case firstName = 100000002
            case dateOfBirth = 100000003
        }
    }
    // viewmodel
    private var viewModel: VerifyWithIdVerificationCodeViewModel
    
    //- timer
    private var timer: Timer?
    
    private var stack: UIStackView!
    weak var delegate: VerifyWithIdInputViewControllerDelegate?
    
    // - scroll view
    private let scrollView = UIScrollView()
    
    // - keyboard related
    private var isKeyBoardOnScreen = false
    private var keyboardHeight: CGFloat?
    
    
    var validationMap: [Int: Bool] = [ViewConstants.FieldTag.lastName.rawValue: false,
                                      ViewConstants.FieldTag.firstName.rawValue: false] {
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
    private lazy var lastNameTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdCode.LastName.localization,
                                                                   placeholder: "", field: .name,
                                                                   keyboardType: .alphabet,
                                                                   showNextInsteadOfReturn: true,
                                                                   excludeBorder: true,
                                                                   backgroundColor: UIColor(resource: .darkYellow))
        textField.delegate = self
        textField.tag = ViewConstants.FieldTag.lastName.rawValue
        textField.textField.text = viewModel.person.lastName
        return textField
    }()
    
    private lazy var firstNameTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdCode.FirstNames.localization,
                                                                   placeholder: "",
                                                                   field: .name,
                                                                   keyboardType: .alphabet,
                                                                   showNextInsteadOfReturn: true,
                                                                   excludeBorder: true,
                                                                   backgroundColor: UIColor(resource: .darkYellow))
        textField.delegate = self
        textField.tag = ViewConstants.FieldTag.firstName.rawValue
        textField.textField.text = viewModel.person.firstName
        return textField
    }()
    
    private lazy var dateOfBirthTextField: TextFieldViewWithValidationAndTitle = {
        let textField: TextFieldViewWithValidationAndTitle = .init(title: L.ConfirmIdentityWithIdCode.DateOfBirth.localization,
                                                                   placeholder: "",
                                                                   field: .name,
                                                                   keyboardType: .alphabet,
                                                                   excludeBorder: true,
                                                                   backgroundColor: UIColor(resource: .darkYellow))
        textField.delegate = self
        textField.tag = ViewConstants.FieldTag.dateOfBirth.rawValue
        textField.textField.text = viewModel.person.dateOfBirth
        return textField
    }()
    
    // - generated code label
    private lazy var generatedCodeLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    // - show eduID service desk button
    private lazy var showEduIDServiceDeskButton: EduIDButton = {
        let button: EduIDButton = .init(type: .primary, buttonTitle: L.ConfirmIdentityWithIdCode.ShowServiceDesksButton.localization)
        button.addTarget(self, action: #selector(onShowEduIDServiceDeskButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // - go to home page button
    private lazy var goToHomePageButton: EduIDButton = {
        let button: EduIDButton = .init(type: .borderedGray, buttonTitle: L.ConfirmIdentityWithIdCode.GoToHomePageButton.localization)
        button.addTarget(self, action: #selector(onGoToHomePageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // - delete verification code button
    private lazy var deleteVerificationCodeButton: EduIDButton = {
        let button: EduIDButton = .init(type: .borderedRed, buttonTitle: L.ConfirmIdentityWithIdCode.DeleteVerificationCodeButton.localization)
        button.addTarget(self, action: #selector(onDeleteVerificationCodeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - init
    init(viewModel: VerifyWithIdVerificationCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .verifyWithIdVerificationCodeScreen
        view.backgroundColor = .white
        setupUI()
        setupTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        timer = nil
    }
    
    private func setupUI() {
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
                
        // - scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()

        let mainTitle: UILabel = UILabel.posterTextLabelBicolor(
            text: L.ConfirmIdentityWithIdCode.Title.localization,
            size: 24,
            primary: L.ConfirmIdentityWithIdCode.Title.localization
        )
        
        let mainDescription = UILabel.subtitleLabel(text: L.ConfirmIdentityWithIdCode.Explanation.localization)
        
        // - generated code container
        let generatedCodeContainer: UIView = getContainer()
        setGeneratedTextLabel(with: viewModel.controlCode)
        generatedCodeContainer.addSubview(generatedCodeLabel)
        
        // - textfield container
        let textFieldsContainer: UIView = getContainer()
        
        // - textField stack view
        let spacer: UIView = .init()
        let textFieldStack: UIStackView = .init(arrangedSubviews: [lastNameTextField,
                                                                   firstNameTextField,
                                                                   dateOfBirthTextField,
                                                                   spacer])
        textFieldStack.axis = .vertical
        textFieldStack.alignment = .center
        textFieldStack.distribution = .fill
        textFieldStack.spacing = .zero
        
        textFieldsContainer.addSubview(textFieldStack)
        
        // - correct typo
        let madeTypoLabel: UILabel = .init()
        madeTypoLabel.text = L.ConfirmIdentityWithIdCode.MadeATypo.Label.localization
        madeTypoLabel.font = UIFont.sourceSansProRegular(size: 18)
        madeTypoLabel.textColor = UIColor.textColor
        
        let editLabel: UILabel = .init()
        editLabel.attributedText = NSAttributedString(
            string: L.ConfirmIdentityWithIdCode.MadeATypo.Link.localization,
            attributes: [
                .font: UIFont.sourceSansProRegular(size: 18),
                .foregroundColor: UIColor.backgroundColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.backgroundColor
            ]
        )
        editLabel.isUserInteractionEnabled = true
        editLabel.addGestureRecognizer(gestureRecognizerForEditDetailsText())
        
        let madeTypoStack: UIStackView = .init(arrangedSubviews: [madeTypoLabel,
                                                                  editLabel])
        madeTypoStack.axis = .horizontal
        madeTypoStack.alignment = .center
        madeTypoStack.distribution = .fill
        madeTypoStack.spacing = 2
        
        textFieldsContainer.addSubview(madeTypoStack)
        
        //- what is next stack
        let whatsNextLabel: UILabel = .init()
        whatsNextLabel.text = L.ConfirmIdentityWithIdCode.WhatsNext.localization
        whatsNextLabel.font = UIFont.sourceSansProBold(size: 18)
        whatsNextLabel.textColor = UIColor.textColor
        
        let whatsNextDescriptionLabel: UILabel = .init()
        whatsNextDescriptionLabel.text = L.ConfirmIdentityWithIdCode.ScheduleAnAppointment.localization
        whatsNextDescriptionLabel.numberOfLines = .zero
        whatsNextDescriptionLabel.font = UIFont.sourceSansProRegular(size: 18)
        whatsNextDescriptionLabel.textColor = UIColor.textColor
        
        let divider: UIView = .init()
        divider.backgroundColor = UIColor.lightGray
        
        let proveOtherWayLabel: UILabel = .init()
        proveOtherWayLabel.text = L.ConfirmIdentityWithIdCode.ProveIdentityOtherWay.localization
        proveOtherWayLabel.numberOfLines = .zero
        proveOtherWayLabel.font = UIFont.sourceSansProRegular(size: 14)
        proveOtherWayLabel.textColor = UIColor.textColor
        
        let whatsNextStackView: UIStackView = .init(arrangedSubviews: [whatsNextLabel,
                                                                       whatsNextDescriptionLabel,
                                                                       showEduIDServiceDeskButton,
                                                                       goToHomePageButton,
                                                                       divider,
                                                                       proveOtherWayLabel,
                                                                       deleteVerificationCodeButton])
        whatsNextStackView.axis = .vertical
        whatsNextStackView.distribution = .fill
        whatsNextStackView.alignment = .center
        whatsNextStackView.spacing = 25
        
        whatsNextStackView.setCustomSpacing(15, after: showEduIDServiceDeskButton)
        
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle,
                                               generatedCodeContainer,
                                               mainDescription,
                                               textFieldsContainer,
                                               whatsNextStackView])
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
        generatedCodeContainer.widthToSuperview(offset: -48)
        generatedCodeContainer.height(90)
        generatedCodeLabel.centerInSuperview()
        textFieldsContainer.widthToSuperview(offset: -48)
        textFieldsContainer.height(380)
        textFieldStack.widthToSuperview(offset: -48)
        textFieldStack.centerInSuperview()
        spacer.height(20)
        madeTypoStack.centerX(to: textFieldsContainer)
        madeTypoStack.bottomToSuperview(offset: -25)
        whatsNextLabel.widthToSuperview(offset: -48)
        whatsNextDescriptionLabel.widthToSuperview(offset: -48)
        showEduIDServiceDeskButton.widthToSuperview(offset: -48)
        goToHomePageButton.widthToSuperview(offset: -48)
        divider.height(2)
        divider.widthToSuperview(offset: -48)
        proveOtherWayLabel.widthToSuperview(offset: -48)
        deleteVerificationCodeButton.widthToSuperview(offset: -48)
        lastNameTextField.widthToSuperview()
        firstNameTextField.widthToSuperview()
        dateOfBirthTextField.widthToSuperview()
        stack.bottom(to: scrollView, offset: view.safeAreaInsets.bottom)
        
    }
    
    private func setGeneratedTextLabel(with code: String) {
        generatedCodeLabel.attributedText = NSAttributedString(
            string: code,
            attributes: [
                .font: UIFont.sourceSansProSemiBold(size: 45),
                .foregroundColor: UIColor.textColor,
                .kern: 10.0
            ]
        )
    }
    
    private func getContainer() -> UIView {
        let coontainer: UIView = .init()
        coontainer.backgroundColor = UIColor(resource: .fallbackYellow)
        coontainer.layer.cornerRadius = 8
        coontainer.layer.borderWidth = 1
        coontainer.layer.borderColor = UIColor(resource: .fallbackButtonTitleAndStroke).cgColor
        coontainer.layer.masksToBounds = true
        return coontainer
    }
    
    @objc private func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc private func onShowEduIDServiceDeskButtonTapped() {
        if let url = URL(string: L.ConfirmIdentityWithIdCode.ServiceDeskUrl.localization) {
            delegate?.openInWebView(url)
        }
    }
    
    @objc private func onGoToHomePageButtonTapped() {
        // TODO:
    }
    
    @objc private func onDeleteVerificationCodeButtonTapped() {
        Task {
            await viewModel.deleteVerificationCode()
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    // - edit mode related
    private func gestureRecognizerForEditDetailsText() -> UITapGestureRecognizer {
        let gestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(popViewController))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        return gestureRecognizer
    }
    
    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: ValidatedTextFieldDelegate
extension VerifyWithIdVerificationCodeViewController: ValidatedTextFieldDelegate {
    
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

// MARK: Check control code
extension VerifyWithIdVerificationCodeViewController {
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: #selector(checkControlCodeValidation),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func checkControlCodeValidation() {
        Task {
            let controlCodeIsStillValid = await viewModel.controlCodeIsStillValid()
            if !controlCodeIsStillValid {
                navigationController?.popToRootViewController(animated: true)
                timer?.invalidate()
            }
        }
    }
}

// MARK: Keyboard presentation
extension VerifyWithIdVerificationCodeViewController {
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
        showEduIDServiceDeskButton.isEnabled = state
    }
}
