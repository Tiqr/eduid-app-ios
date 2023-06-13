import UIKit
import TinyConstraints
import KeychainSwift

class HomeViewController: UIViewController, ScreenWithScreenType {
    
    //MARK: - screen type
    var screenType: ScreenType = .homeScreen
    weak var delegate: HomeViewControllerDelegate?
    var buttonStack: AnimatedHStackView!
    private var childScreenMode: HomeViewChildScreensType = .none
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(loadViewWhenReceivingNotification), name: .firstTimeAuthorizationCompleteWithSecretPresent, object: nil)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonStack.animate()
        screenType.configureNavigationItem(item: navigationItem, target: self, action: nil, secondaryAction: #selector(logOff))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .firstTimeAuthorizationCompleteWithSecretPresent, object: nil)
    }
    
    func setupUI() {
        //MARK: - PosterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your eduID app\nis ready for use", size: 32, primary: "Your eduID app", alignment: .center)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(posterLabel)
        posterLabel.width(to: view)
        posterLabel.centerX(to: view)
        posterLabel.topToSuperview(offset: view.frame.height / 6)
        
        //MARK: - blue bottom view
        let blueBottomView = UIView()
        blueBottomView.translatesAutoresizingMaskIntoConstraints = false
        blueBottomView.backgroundColor = .backgroundColor
        view.addSubview(blueBottomView)
        blueBottomView.leading(to: view)
        blueBottomView.width(to: view)
        blueBottomView.bottom(to: view)
        blueBottomView.height(236)
        
        //MARK: - image
        let image = UIImageView(image: .readyForUse)
        image.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        image.leading(to: view)
        image.width(to: view)
        image.aspectRatio(0.761)
        image.contentMode = .scaleAspectFit
        image.bottom(to: view, offset: -76)
        
        //MARK: - button stack
        let securityButton = UIButton()
        securityButton.setImage(.security, for: .normal)
        securityButton.contentMode = .scaleAspectFit
        securityButton.height(51)
        securityButton.addTarget(self, action: #selector(securityTapped), for: .touchUpInside)
        let securityLabel = UILabel()
        securityLabel.font = .nunitoBold(size: 14)
        securityLabel.text = "Security"
        securityLabel.textAlignment = .center
        securityLabel.width(100)
        securityLabel.textColor = .white
        let securityStack = UIStackView(arrangedSubviews: [securityButton, securityLabel])
        securityStack.axis = .vertical
        securityStack.width(100)
        securityStack.spacing = 3
        
        let personalInfoButton = UIButton()
        personalInfoButton.setImage(.personalInfo, for: .normal)
        personalInfoButton.contentMode = .scaleAspectFit
        personalInfoButton.height(51)
        personalInfoButton.addTarget(self, action: #selector(personalInfoTapped), for: .touchUpInside)
        let personalInfoLabel = UILabel()
        personalInfoLabel.font = .nunitoBold(size: 14)
        personalInfoLabel.text = "Personal info"
        personalInfoLabel.textAlignment = .center
        personalInfoLabel.textColor = .white
        let personalInfoStack = UIStackView(arrangedSubviews: [personalInfoButton, personalInfoLabel])
        personalInfoStack.axis = .vertical
        personalInfoStack.width(100)
        personalInfoStack.spacing = 3
        
        let activityButton = UIButton()
        activityButton.setImage(.activity, for: .normal)
        activityButton.contentMode = .scaleAspectFit
        activityButton.height(51)
        activityButton.addTarget(self, action: #selector(activityTapped), for: .touchUpInside)
        let activityLabel = UILabel()
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        activityLabel.font = .nunitoBold(size: 14)
        activityLabel.textColor = .white
        let activityStack = UIStackView(arrangedSubviews: [activityButton, activityLabel])
        activityStack.axis = .vertical
        activityStack.width(100)
        activityStack.spacing = 3
        
        let qrCodeButton = UIButton()
        qrCodeButton.setImage(.qrCodeIcon, for: .normal)
        qrCodeButton.contentMode = .scaleAspectFit
        qrCodeButton.height(51)
        qrCodeButton.addTarget(self, action: #selector(showScanScreen), for: .touchUpInside)
        let qrCodeLabel = UILabel()
        qrCodeLabel.font = .nunitoBold(size: 14)
        qrCodeLabel.text = "Scan QR"
        qrCodeLabel.textAlignment = .center
        qrCodeLabel.width(100)
        qrCodeLabel.textColor = .white
        let qrStack = UIStackView(arrangedSubviews: [qrCodeButton, qrCodeLabel])
        qrStack.axis = .vertical
        qrStack.width(100)
        qrStack.spacing = 3
        
        buttonStack = AnimatedHStackView(arrangedSubviews: [qrStack, personalInfoStack, securityStack, activityStack])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = -15
        view.addSubview(buttonStack)
        buttonStack.centerX(to: view)
        buttonStack.bottom(to: view, offset: -60)
        buttonStack.height(100)
        
        buttonStack.hideAndTriggerAll()
        
    }
    
    //MARK: - action buttons
    
    @objc func logOff() {
        testFuncRemoveAccessToken()
    }
    
    private func testFuncRemoveAccessToken() {
        //TODO: REMOVE ACCESS TOKEN
        UserDefaults.standard.set("nil", forKey: OnboardingManager.userdefaultsFlowTypeKey)
        AppAuthController.shared.clearAuthState()
    }
    
    @objc func showScanScreen() {
        delegate?.homeViewControllerShowScanScreen(viewController: self)
    }
    
    @objc func securityTapped() {
        presentView(for: .security)
    }
    
    @objc func personalInfoTapped() {
        presentView(for: .personalInfo)
    }
    
    @objc func activityTapped() {
        presentView(for: .activity)
    }
    
    private func askForAuthorisationIfNeeded() -> Bool {
        if !AppAuthController.shared.isLoggedIn() {
            AppAuthController.shared.authorize(viewController: self)
            return true
        }
        return false
    }
    
    fileprivate func presentView(for childScreen: HomeViewChildScreensType) {
        if askForAuthorisationIfNeeded(){
            childScreenMode = childScreen
        } else {
            load(childScreen)
        }
    }
    
    private func load(_ screen: HomeViewChildScreensType) {
        switch screen {
        case .activity:
            delegate?.homeViewControllerShowActivityScreen(viewController: self)
        case .security:
            delegate?.homeViewControllerShowSecurityScreen(viewController: self)
        case .personalInfo:
            delegate?.homeViewControllerShowPersonalInfoScreen(viewController: self)
        default: break
        }
    }
    
    @objc private func loadViewWhenReceivingNotification(_ notification: Notification) {
        if let notificationObject = notification.object as? String {
            delegate?.homeViewControllerShowAuthenticationScreen(with: notificationObject)
        }
        load(childScreenMode)
    }
}

enum HomeViewChildScreensType {
    case activity, security, personalInfo, none
}
