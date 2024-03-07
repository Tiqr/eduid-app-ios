import UIKit
import TinyConstraints
import OpenAPIClient

class CreateEduIDEnterPhoneNumberViewController: CreateEduIDBaseViewController, ValidatedTextFieldDelegate {
    
    private var stack: AnimatedVStackView!
    private var spaceView: UIView!
    
    // - phone textfield
    let validatedPhoneTextField = TextFieldViewWithValidationAndTitle(title: L.CreateEduID.EnterPhoneNumber.PhoneFieldTitle.localization,
                                                                      placeholder: L.CreateEduID.EnterPhoneNumber.PhoneFieldPlaceholder.localization,
                                                                      field: .phone, keyboardType: .numberPad)
    
    // - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: L.CreateEduID.EnterPhoneNumber.VerifyPhoneNumber.localization)
    var bottomConstraint: Constraint? = nil
    private var viewModel: CreateEduIDEnterPhoneNumberViewModel
    
    //MARK: - init
    init(viewModel: CreateEduIDEnterPhoneNumberViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.alertErrorHandlerDelegate = self
        viewModel.phoneNumberReceivedClosure = { [weak self] result in
            self?.goToConfirmSmsScreen()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .enterPhoneScreen
        
        setupUI()
        verifyButton.addTarget(self, action: #selector(showNextScreen(_:)), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [2])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = validatedPhoneTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        verifyButton.isUserInteractionEnabled = true
    }
    
    //MARK: - setup UI
    func setupUI() {
        // - phone textfield delegate
        validatedPhoneTextField.delegate = self
        
        // - button state
        verifyButton.isEnabled = false
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: L.CreateEduID.Created.MainTitleLabel.localization, size: 24)
        
        // - textView Parent
        let textViewParent = UIView()
        
        // - create the textView
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string: L.CreateEduID.EnterPhoneNumber.MainText.localization,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : UIFont.sourceSansProSemiBold(size: 16)], range: NSRange(location: 0, length: Int(L.CreateEduID.EnterPhoneNumber.BoldRange.localization) ?? .zero))
        textLabel.attributedText = attributedText
        
        textViewParent.addSubview(textLabel)
        textLabel.edges(to: textViewParent)
        textLabel.sizeToFit()
        
        // - Space
        spaceView = UIView()
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textViewParent, validatedPhoneTextField, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        
        view.addSubview(stack)
        
        // - add constraints
        stack.widthToSuperview(offset: -48, usingSafeArea: true)
        stack.centerXToSuperview()
        stack.topToSuperview(offset: 24, usingSafeArea: true)
        bottomConstraint = stack.bottomToSuperview(offset: 24, usingSafeArea: true)
        
        
        textViewParent.width(to: stack)
        posterLabel.height(34)
        verifyButton.width(to: stack, offset: -24)
        validatedPhoneTextField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
    
    //MARK: - textfield validation method
    func updateValidation(with value: String, isValid: Bool, from tag: Int) {
        verifyButton.isEnabled = isValid
    }
    
    func keyBoardDidReturn(tag: Int) {
        resignKeyboardResponder()
    }
    
    func didBecomeFirstResponder(tag: Int) {
    }
    
    @objc
    func resignKeyboardResponder() {
        _ = validatedPhoneTextField.resignFirstResponder()
    }
    
    override func showNextScreen(_ sender: UIButton? = nil) {
        sender?.isUserInteractionEnabled = false
        viewModel.sendPhoneNumber(number: validatedPhoneTextField.textField.text ?? "")
    }
    
    func goToConfirmSmsScreen() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}

extension CreateEduIDEnterPhoneNumberViewController {
    
    @objc
    func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let height = keyboardFrame.height
        // Hide some views so that we can show everything
        self.spaceView.isHidden = true
        self.stack.spacing = 8
        self.bottomConstraint?.constant = -24 - height
    }
    
    @objc
    func keyboardDidHide() {
        // Show views again
        self.bottomConstraint?.constant = -24
        self.spaceView.isHidden = false
        self.stack.spacing = 32
    
    }
}

extension CreateEduIDEnterPhoneNumberViewController: AlertErrorHandlerDelegate {
    func presentAlert(with error: Error) {
        let alertController = UIAlertController(title: error.eduIdResponseError().title,
                                                message: error.eduIdResponseError().message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .cancel) { [weak self] _ in
            self?.verifyButton.isUserInteractionEnabled = true
        }
        alertController.addAction(alertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
