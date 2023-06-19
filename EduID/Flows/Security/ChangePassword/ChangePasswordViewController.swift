import UIKit
import TinyConstraints

class ChangePasswordViewController: ScrollingTextFieldsViewController {
    
    static let tagOfRepeatPasswordField = 3
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    // - view model
    var viewModel: ChangePasswordViewModel
    
    // - reset / add password button
    private var requestButton: EduIDButton!
    private var requestLoadingIndicator: UIActivityIndicatorView!
    
    private var deleteButton: EduIDButton? = nil
    private var deleteLoadingButtonIndicator: UIActivityIndicatorView!
    
    private var newPasswordField: TextFieldViewWithValidationAndTitle!
    private var repeatPasswordField: TextFieldViewWithValidationAndTitle!
    
    
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
            
            _ = (self?.stack.arrangedSubviews[self?.nextTextfieldBy(tag: tag) ?? 0] as? TextFieldViewWithValidationAndTitle)?.becomeFirstResponder()
            self?.scrollViewToTextField(index: self?.nextTextfieldBy(tag: tag) ?? 0)
        }
        
        viewModel.setRequestButtonEnabled = { [weak self] isEnabled in
            self?.requestButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldBecameFirstResponderClosure = { [weak self] tag in
            guard Date().timeIntervalSince(loadedTime) > 2 else { return }
            self?.scrollViewToTextField(index: tag)
        }
        
        viewModel.passwordsMatchClosure = { [weak self] passwordsMatch in
            if !passwordsMatch {
                self?.repeatPasswordField.setValidationError(L.ChangePassword.Label.MismatchError.localization)
            } else {
                self?.repeatPasswordField.setValidationError(nil)
            }
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
        
        stack.animate(onlyThese: [2, 3])
    }
    
    //MARK: - setup UI
    private func setupUI() {
        // - scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        let titleText: String
        if viewModel.isForAdd {
            titleText = L.ChangePassword.Title.AddPassword.localization
        } else {
            titleText = L.ChangePassword.Title.ChangePassword.localization
        }
        
        // - poster label
        let posterLabel = UILabel.posterTextLabelBicolor(text: titleText, primary: titleText)
        // - text
        let textLabel = UILabel.plainTextLabelPartlyBold(
            text: L.ChangePassword.Description.NewPassword.localization,
            partBold: L.ChangePassword.Description.BoldPart.localization)
        
        // - new password field
        newPasswordField = TextFieldViewWithValidationAndTitle(
            title: L.ChangePassword.Label.NewPassword.localization,
            placeholder: L.ChangePassword.Label.Placeholder.localization,
            field: .password,
            keyboardType: .default,
            isPassword: true
        )
        newPasswordField.delegate = viewModel
        newPasswordField.tag = 2
         
        // - repeat password
        repeatPasswordField = TextFieldViewWithValidationAndTitle(
            title: L.ChangePassword.Label.RepeatPassword.localization,
            placeholder: L.ChangePassword.Label.Placeholder.localization,
            field: .password,
            keyboardType: .default,
            isPassword: true
        )
        repeatPasswordField.delegate = viewModel
        repeatPasswordField.tag = 3
        
        let buttonTitle: String
        if viewModel.isForAdd {
            buttonTitle = L.ChangePassword.Button.Add.localization
        } else {
            buttonTitle = L.ChangePassword.Button.Reset.localization
        }
        
        let requestContainer = UIView()
        requestButton = EduIDButton(type: .primary, buttonTitle: buttonTitle)
        requestContainer.addSubview(requestButton)
        requestButton.edgesToSuperview()
        requestLoadingIndicator = UIActivityIndicatorView()
        requestContainer.addSubview(requestLoadingIndicator)
        requestLoadingIndicator.heightToSuperview()
        requestLoadingIndicator.width(30)
        requestLoadingIndicator.centerXToSuperview(offset: 115)
        requestLoadingIndicator.isHidden = true
        
        // - stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, textLabel, newPasswordField, repeatPasswordField, requestContainer])
        
        scrollView.addSubview(stack)
        
        if !viewModel.isForAdd {
            stack.setCustomSpacing(40, after: requestContainer)
            let divider = UIView()
            divider.backgroundColor = .dividerColor
            stack.addArrangedSubview(divider)
            divider.height(1)
            divider.widthToSuperview()
            
            let deletePasswordTitle = UILabel.posterTextLabelBicolor(
                text: L.ChangePassword.DeleteHeader.Title.localization,
                primary: L.ChangePassword.DeleteHeader.Title.localization
            )
            let deletePasswordDescription = UILabel.plainTextLabelPartlyBold(text: L.ChangePassword.DeleteHeader.Description.localization, partBold: ""
            )
            deleteButton = EduIDButton(type: .ghost, buttonTitle: L.ChangePassword.Button.Delete.localization)
            
            stack.addArrangedSubview(deletePasswordTitle)
            stack.addArrangedSubview(deletePasswordDescription)
            stack.setCustomSpacing(40, after: divider)

            deletePasswordTitle.widthToSuperview()
            deletePasswordDescription.widthToSuperview()
            
            let deleteContainer = UIView()
            deleteContainer.addSubview(deleteButton!)
            
            stack.addArrangedSubview(deleteContainer)
            
            deleteButton!.edgesToSuperview()
            deleteContainer.widthToSuperview()
            
            deleteLoadingButtonIndicator = UIActivityIndicatorView()
            deleteContainer.addSubview(deleteLoadingButtonIndicator!)
            deleteLoadingButtonIndicator!.centerXToSuperview(offset: 115)
            deleteLoadingButtonIndicator.heightToSuperview()
            deleteLoadingButtonIndicator!.width(30)
            deleteLoadingButtonIndicator!.isHidden = true
            
            deleteButton!.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        }
        
        // - constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 40, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        posterLabel.width(to: stack)
        textLabel.width(to: stack)
        newPasswordField.width(to: stack)
        repeatPasswordField.width(to: stack)
        requestContainer.width(to: stack)
        stack.setCustomSpacing(40, after: posterLabel)
        
        requestButton.isEnabled = false
        
        requestButton.addTarget(self, action: #selector(resetOrAddAction), for: .touchUpInside)

        stack.hideAndTriggerAll(onlyThese: [2, 3])
        
    }
    
    func nextTextfieldBy(tag: Int) -> Int {
        switch tag {
        case 2:
            return 3
        default:
            return 0
        }
    }

    @objc
    func resetOrAddAction() {
        Task {
            requestButton.isEnabled = false
            requestLoadingIndicator.isHidden = false
            requestLoadingIndicator.startAnimating()
            do {
                let response = try await viewModel.resetOrAddPassword()
                // Success, go back to main screen
                delegate?.goToMainScreenWithPersonalInfo(response)
            } catch {
                showError(error)
            }
            requestLoadingIndicator.stopAnimating()
            requestLoadingIndicator.isHidden = true
            requestButton.isEnabled = true
        }
    }
    
    @objc
    func deleteAction() {
        Task {
            deleteButton?.isEnabled = false
            deleteLoadingButtonIndicator?.isHidden = false
            deleteLoadingButtonIndicator?.startAnimating()
            do {
                let response = try await viewModel.deletePassword()
                // Success, go back to main screen
                delegate?.goToMainScreenWithPersonalInfo(response)
            } catch {
                showError(error)
            }
            deleteLoadingButtonIndicator?.stopAnimating()
            deleteLoadingButtonIndicator?.isHidden = true
            deleteButton?.isEnabled = true
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: L.Generic.RequestError.Title.localization,
            message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    override func goBack() {
        delegate?.goBack(viewController: self)
    }
    
    @objc override func resignKeyboardResponder() {
        _ = newPasswordField.resignFirstResponder()
        _ = repeatPasswordField.resignFirstResponder()
    }

}
