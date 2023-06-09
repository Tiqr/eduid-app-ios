import UIKit
import TinyConstraints

class CreateEduIDLandingPageViewController: CreateEduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .landingScreen
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack?.animate(onlyThese: [3, 4, 5])
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(showScanScreen))
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - setupUI
    private func setupUI() {
                
        // - add logo
        let logo = UIImageView(image: .eduIDLogo)
        logo.height(60)
        logo.width(150)
        
        // - add label
        let posterLabel = UILabel.posterTextLabel(text: "Personal account\nfor Education and Research", size: 24, alignment: .center)
        
        // - add image
        let imageView = UIImageView(image: .landingPageImage)
        imageView.contentMode = .scaleAspectFit
        imageView.height(252, priority: .defaultLow)
        imageView.width(141)
        
        // - space
        let upperSpaceView = UIView()
        let lowerSpaceView = UIView()
        
        // - buttons
        let signInButton = EduIDButton(type: .primary, buttonTitle: "Sign in")
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        let scanQRButton = EduIDButton(type: .primary, buttonTitle: "Scan a QR code")
        scanQRButton.addTarget(self, action: #selector(showScanScreen), for: .touchUpInside)
        let noEduIDYetButton = EduIDButton(type: .naked, buttonTitle: "I don't have an eduId")
        
        //the action for this button is on CreateEduIDBaseViewController superclass
        noEduIDYetButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [logo, posterLabel, upperSpaceView, imageView, lowerSpaceView, signInButton, scanQRButton, noEduIDYetButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        view.addSubview(stack)
        upperSpaceView.height(to: lowerSpaceView)
        
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        signInButton.width(to: stack, offset: -24)
        scanQRButton.width(to: stack, offset: -24)
        noEduIDYetButton.width(to: stack, offset: -24)
        posterLabel.width(to: stack)
        
        stack.setCustomSpacing(24, after: signInButton)
        stack.setCustomSpacing(24, after: scanQRButton)
        
        stack.hideAndTriggerAll(onlyThese: [3, 4, 5])
    }
    
    //MARK: - button actions
    
    @objc
    func signInTapped() {
        AppAuthController.shared.authorize(viewController: self)
    }

}
