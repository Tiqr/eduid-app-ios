import UIKit
import TinyConstraints

class CheckEmailViewController: EduIDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Check your email", size: 24)
        
        //MARK: - messageLabel
        let messageLabel = UILabel()
        messageLabel.font = .sourceSansProRegular(size: 16)
        messageLabel.textColor = .charcoal
        messageLabel.text = "To sign in, click the link in the email we sent to juanCarlos02@hotmail.com."
        messageLabel.numberOfLines = 2
        
        //MARK: - activityIndicatorView
        let activity = UIActivityIndicatorView(style: .large)
        activity.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        activity.tintColor = .gray
        activity.width(100)
        activity.height(100)

        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, messageLabel, activity])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)
        acti
    }
}
