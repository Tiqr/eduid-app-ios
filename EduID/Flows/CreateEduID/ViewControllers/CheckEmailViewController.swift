import UIKit
import TinyConstraints

class CheckEmailViewController: CreateEduIDBaseViewController {
    
    var emailToCheck: String? = nil
    var subtitleOverride: String? = nil
    
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
            text: subtitleOverride ?? L.MagicLink.Info(args: email).localization,
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

        @objc func dismissInfoScreen() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: true)
        } else {
            goBack()
        }
    }
    
    override func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
