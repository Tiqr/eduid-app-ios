import UIKit
import TinyConstraints


class PincodeBaseViewController: CreateEduIDBaseViewController {
    
    // - viewmodel
    let viewModel: PinViewModel
    // - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.VerifyPin.localization)
    
    // - pin stack view
    let pinStack = AnimatedHStackView()
    
    var mainStack = UIStackView()
    // - activity indicator
    let activity = UIActivityIndicatorView(style: .large)
    
    // - configurable labels
    var posterLabel: UILabel!
    var textLabel: UILabel!
    
    // - flag for secure input
    var isSecure = false
    
    private var pinFieldMap: [Int: PinTextFieldView] = .init()

    //MARK: - init
    init(viewModel: PinViewModel, isSecure: Bool) {
        self.isSecure = isSecure
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        screenType = .smsChallengeScreen
        
        viewModel.focusPinField = { [weak self] tag in
            (self?.pinStack.arrangedSubviews[tag + 1] as? PinTextFieldView)?.focus()
        }
        
        viewModel.enableVerifyButton = { [weak self] isEnabled in
            self?.verifyButton.isEnabled = isEnabled
        }
        
        viewModel.resignKeyboardFocus = { [weak self] in
            self?.resignKeyboardFocus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinStack.animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinStack.arrangedSubviews.forEach { pinView in
            (pinView as? PinTextFieldView)?.textfield.text = ""
        }
        _ = (pinStack.arrangedSubviews.first as? PinTextFieldView)?.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        verifyButton.isUserInteractionEnabled = true
    }
    
    //MARK: - setup ui
    func setupUI() {
        // - posterLabel
        let posterParent = UIView()
        posterLabel = UILabel.posterTextLabel(text: L.PinAndBioMetrics.CheckMessages.localization, size: 24)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
        // - create the textView
        let textLabelParent = UIView()
        textLabel = UILabel.plainTextLabelPartlyBold(text:L.PinAndBioMetrics.EnterSixDigitCode.localization, partBold: L.PinAndBioMetrics.SixDigitCode.localization)
        
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        // - pin fields
        pinStack.axis = .horizontal
        pinStack.distribution = .equalCentering
        pinStack.height(50)
        ((screenType == .pincodeScreen) ? 0...3 : 0...5).forEach { integer in
            let pinField = PinTextFieldView(isSecure: isSecure, screenType: screenType)
            pinField.tag = integer
            pinField.delegate = viewModel
            pinField.pinViewDelegate = self
            pinStack.addArrangedSubview(pinField)
            pinFieldMap[integer] = pinField
        }
        // - activityIndicatorView
        activity.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        activity.tintColor = .gray
        activity.width(100)
        activity.height(100)
        
        // - Space
        let spaceView = UIView()
        
        // - create the stackview
        mainStack = UIStackView(arrangedSubviews: [posterParent, textLabelParent, pinStack, activity, spaceView, verifyButton])
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.distribution = .fill
        mainStack.alignment = .center
        mainStack.spacing = 32
        view.addSubview(mainStack)
        
        // - add constraints
        mainStack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textLabel.width(to: mainStack)
        posterLabel.height(34)
        posterParent.width(to: mainStack)
        verifyButton.width(to: mainStack, offset: -24)
        pinStack.width(to: mainStack)
        
        pinStack.hideAndTriggerAll()
        
        // verify button state and action
        verifyButton.isEnabled = false
        verifyButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    //MARK: - gesture action resign keyboard focus
    @objc func resignKeyboardFocus() {
        pinStack.arrangedSubviews.forEach { pinview in
            pinview.resignFirstResponder()
        }
    }
}

extension PincodeBaseViewController: PinViewDelegate {
    func deletePreviousInput(with currentTag: Int) {
        if let pinView = pinFieldMap[(currentTag - 1)] {
            pinView.textfield.text = nil
            pinView.textfield.becomeFirstResponder()
        }
    }
    
    func autoFillPinField(with verificationCode: String) {
        var currentIndex: Int = .zero
        for character in verificationCode {
            if let pinField = pinFieldMap[currentIndex] {
                pinField.textfield.text = "\(character)"
                currentIndex += 1
            }
        }
    }
}
