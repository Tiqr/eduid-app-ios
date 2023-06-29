import UIKit
import TinyConstraints

class CheckEmailViewController: CreateEduIDBaseViewController {
    
    var emailToCheck: String? = nil
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .checkMailScreen
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: .createEduIDDidReturnFromMagicLink, object: nil)
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: L.MagicLink.Header.localization, size: 24)
        
        // - messageLabel
        let email = emailToCheck ?? UserDefaults.standard.string(forKey: CreateEduIDEnterPersonalInfoViewController.emailKeyUserDefaults) ?? ""
        let messageLabel = UILabel.plainTextLabelPartlyBold(
            text: L.MagicLink.Info(args: email).localization,
            partBold: email)
        let messageParent = UIView()
        messageParent.addSubview(messageLabel)
        messageLabel.edges(to: messageParent)
        
        // - activityIndicatorView
        let activity = UIActivityIndicatorView(style: .large)
        activity.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        activity.tintColor = .gray
        activity.width(100)
        activity.height(100)
        activity.startAnimating()
        
        // - email options buttons
        let gmailImage = UIImageView(image: .gmail)
        gmailImage.width(30)
        gmailImage.height(30)
        gmailImage.contentMode = .scaleAspectFit
        let gmailButton = UIButton()
        gmailButton.setAttributedTitle(NSAttributedString(string: L.MagicLink.OpenGMail.localization, attributes: [.font: UIFont.sourceSansProSemiBold(size: 18), .foregroundColor: UIColor.secondaryColor]), for: .normal)
        let gmailStack = UIStackView(arrangedSubviews: [gmailImage, gmailButton])
        gmailStack.alignment = .center
        gmailStack.spacing = 8
        gmailButton.tag = 0
        
        let outlookImage = UIImageView(image: .outlook)
        outlookImage.width(30)
        outlookImage.height(30)
        outlookImage.contentMode = .scaleAspectFit
        let outlookButton = UIButton()
        outlookButton.contentMode = .scaleAspectFit
        outlookButton.setAttributedTitle(NSAttributedString(string: L.MagicLink.OpenOutlook.localization, attributes: [.font: UIFont.sourceSansProSemiBold(size: 18), .foregroundColor: UIColor.secondaryColor]), for: .normal)
        let outlookStack = UIStackView(arrangedSubviews: [outlookImage, outlookButton])
        outlookStack.alignment = .center
        outlookStack.spacing = 8
        outlookButton.tag = 1
        
        let emailOptionsVStack = UIStackView(arrangedSubviews: [gmailStack, outlookStack])
        emailOptionsVStack.axis = .vertical
        emailOptionsVStack.alignment = .leading
        emailOptionsVStack.spacing = 10
        
        
        // - Space
        let spaceView = UIView()
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, messageParent, activity, emailOptionsVStack, spaceView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        gmailButton.addTarget(self, action: #selector(openWeb(for:)), for: .touchUpInside)
        outlookButton.addTarget(self, action: #selector(openWeb(for:)), for: .touchUpInside)

    }
    
    @objc private func openWeb(for sender: UIButton) {
        switch sender.tag {
        case 0: UIApplication.shared.open(URL(string: "https://gmail.com")!)
        case 1: UIApplication.shared.open(URL(string: "https://login.live.com")!)
        default: break
        }
    }
    
}
