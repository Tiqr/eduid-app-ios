import UIKit
import TinyConstraints

class SecurityLandingViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityLandingScreen
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissSecurityScreen))
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Security settings", size: 24, primary: "Security settings")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
We provide different methods to sign in to your eduID account.
"""
                                                       ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        textLabel.attributedText = attributedText
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        let spaceView = UIView()
        
        // - the info controls
        let firstTitle = NSAttributedString(string: "Sign-in methods", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let firstBodyText = NSMutableAttributedString(string: "Send a magic link to\nedwin.van.de.bospoort@gmail.com", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        firstBodyText.setAttributeTo(part: "edwin.van.de.bospoort@gmail.com", attributes: [.font: UIFont.sourceSansProLight(size: 12), .foregroundColor: UIColor.charcoalColor])
        let firstControl = ActionableControlWithBodyAndTitle(attributedTitle: firstTitle, attributedBodyText: firstBodyText, iconInBody: UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysTemplate), isFilled: true, shadow: true)
        
        let secondBodyText = NSMutableAttributedString(string: "Use a password\n******", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        secondBodyText.setAttributeTo(part: "******", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        let secondControl = ActionableControlWithBodyAndTitle(attributedBodyText: secondBodyText, iconInBody: UIImage(systemName: "square.and.pencil"), isFilled: true, shadow: true)
        
        let thirdBodyText = NSMutableAttributedString(string: "Use a security key\nnot available yet", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        thirdBodyText.setAttributeTo(part: "not available yet", attributes: [.font: UIFont.sourceSansProLight(size: 12)])
        let thirdControl = ActionableControlWithBodyAndTitle(attributedBodyText: thirdBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: false, shadow: true)
        thirdControl.isEnabled = false
        
        let fourthTitle = NSAttributedString(string: "Sign-in settings", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let fourthBodyText = NSMutableAttributedString(string: "Stay logged in", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        fourthBodyText.setAttributeTo(part: "logged in", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let fourthControl = ActionableControlWithBodyAndTitle(attributedTitle: fourthTitle, attributedBodyText: fourthBodyText, iconInBody: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), isFilled: true, shadow: true)
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterParent, textLabelParent, firstControl, secondControl, thirdControl, fourthControl, spaceView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textLabel.width(to: stack)
        posterLabel.width(to: stack)
        firstControl.width(to: stack)
        secondControl.width(to: stack)
        thirdControl.width(to: stack)
        fourthControl.width(to: stack)
        
        // - actions
        firstControl.addTarget(self, action: #selector(enterEmailFlow), for: .touchUpInside)
        secondControl.addTarget(self, action: #selector(enterChangePasswordFlow), for: .touchUpInside)
    }
    
    @objc
    func dismissSecurityScreen() {
        delegate?.securityViewControllerDismissSecurityFlow(viewController: self)
    }
    
    @objc
    func enterEmailFlow() {
        delegate?.securityViewControllerEnterVerifyEmailFlow(viewController: self)
    }
    
    @objc
    func enterChangePasswordFlow() {
        delegate?.securityViewControllerEnterChangePasswordFlow(viewController: self)
    }
}
