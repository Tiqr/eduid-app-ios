import UIKit
import TinyConstraints

class CheckEmailViewController: CreateEduIDBaseViewController {
    
    var emailToCheck: String? = nil
    var subtitleOverride: String? = nil
    
    init(emailToCheck: String? = nil, subtitleOverride: String? = nil) {
        self.emailToCheck = emailToCheck
        self.subtitleOverride = subtitleOverride
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .emailLoginCodeScreen
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNextScreen), name: .createEduIDDidReturnFromMagicLink, object: nil)
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: L.MagicLink.Header.localization, size: 24)
        
        // - messageLabel
        let email = emailToCheck ?? ""
        let messageLabel = UILabel.plainTextLabelPartlyBold(
            text: subtitleOverride ?? L.MagicLink.Info.localization + " " + email,
            partBold: email)
        
        let disclaimerLabel = UILabel.plainTextLabelPartlyBold(text: L.MagicLink.OpenMailDisclaimer.localization, alignment: .center)
        
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
        
        let openMailButton = EduIDButton(type: .primary, buttonTitle: L.MagicLink.OpenMailTitle.localization)
        openMailButton.addTarget(self, action: #selector(openMailClient), for: .touchUpInside)
        openMailButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // - Space
        let spaceView = UIView()
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, messageParent, activity, spaceView, openMailButton, disclaimerLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        posterLabel.height(34)
        openMailButton.width(to: stack)
    }
    
    @objc func openMailClient() {
        if let mailURL = URL(string: "message://") {
             UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
         }
    }
    
    override func goBack() {
        navigationController?.popToRootViewController(animated: true)
    }

}
