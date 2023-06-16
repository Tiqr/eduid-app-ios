import UIKit
import TinyConstraints

class ChangePasswordViewController: ScrollingTextFieldsViewController {
    
    static let tagOfRepeatPasswordField = 4
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    // - view model
    var viewModel: ChangePasswordViewModel
    
    // - reset your password button
    let resetPasswordButton = EduIDButton(type: .primary, buttonTitle: "Reset your password")
    
    //MARK: - init
    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        let loadedTime = Date()
        
        viewModel.makeNextTextFieldFirstResponderClosure = { [weak self] tag in
            guard tag != ChangePasswordViewController.tagOfRepeatPasswordField else {
                self?.resignKeyboardResponder()
                return
            }
            
            //tag + 2 because the stackview's first subview is the poster label and we need the subview after the current, hence + 2
            _ = (self?.stack.arrangedSubviews[self?.nextTextfieldBy(tag: tag) ?? 0] as? TextFieldViewWithValidationAndTitle)?.becomeFirstResponder()
            self?.scrollViewToTextField(index: self?.nextTextfieldBy(tag: tag) ?? 0)
        }
        
        viewModel.setRequestButtonEnabled = { [weak self] isEnabled in
            self?.resetPasswordButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldBecameFirstResponderClosure = { [weak self] tag in
            guard Date().timeIntervalSince(loadedTime) > 2 else { return }
            self?.scrollViewToTextField(index: tag)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .securityChangePasswordScreen
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
        
        stack.animate(onlyThese: [1, 3, 4])
    }
    
    //MARK: - setup UI
    private func setupUI() {
        // - scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Change password", primary: "Change password")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - old password textfield
        let oldPasswordTextField = TextFieldViewWithValidationAndTitle(title: "Your old password", placeholder: "********", field: .password, keyboardType: .default, isPassword: true)
        oldPasswordTextField.delegate = viewModel
        oldPasswordTextField.tag = 1
        
        // - text
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text:
                                                            """
Make sure your new password is at least 15 characters OR at least 8 characters including a number and a uppercase letter.
"""
                                                         , partBold: "Make sure your new password")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // - new password field
        let newPasswordField = TextFieldViewWithValidationAndTitle(title: "Your new password", placeholder: "********", field: .password, keyboardType: .default, isPassword: true)
        newPasswordField.delegate = viewModel
        newPasswordField.tag = 3
         
        // - repeat password
        let repeatPasswordField = TextFieldViewWithValidationAndTitle(title: "Repeat new password", placeholder: "********", field: .password, keyboardType: .default, isPassword: true)
        repeatPasswordField.delegate = viewModel
        repeatPasswordField.tag = 4
        
        // - stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, oldPasswordTextField, textParent, newPasswordField, repeatPasswordField, resetPasswordButton])
        
        scrollView.addSubview(stack)
        
        // - constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: -24, right: -24))
        stack.width(to: scrollView, offset: -48)
        posterLabel.width(to: stack)
        oldPasswordTextField.width(to: stack)
        textParent.width(to: stack)
        newPasswordField.width(to: stack)
        repeatPasswordField.width(to: stack)
        resetPasswordButton.width(to: stack, offset: -24)
        
        // - actions
        resetPasswordButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        
        stack.hideAndTriggerAll(onlyThese: [1, 3, 4])
        
    }
    
    func nextTextfieldBy(tag: Int) -> Int {
        switch tag {
        case 1:
            return 3
        case 3:
            return 4
        default:
            return 0
        }
    }

    @objc
    func resetAction() {
        delegate?.securityViewController(viewController: self, reset: "")
    }
    
    override func goBack() {
        delegate?.goBack(viewController: self)
    }

}
