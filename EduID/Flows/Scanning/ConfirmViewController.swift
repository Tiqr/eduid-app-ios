import UIKit
import TinyConstraints

class ConfirmViewController: BaseViewController {
    
    // - delegate
    weak var delegate: ConfirmViewControllerDelegate?

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        screenType = .confirmScreen
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem)
    }
    
    //MARK: - setupUI
    func setupUI() {
        //top poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: L.PinAndBioMetrics.LoginRequest.localization, primary: L.PinAndBioMetrics.LoginRequest.localization)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let upperspace = UIView()
        
        // shield image and message
        let shieldParent = UIView()
        let shieldImageView = UIImageView(image: .shield)
        shieldImageView.translatesAutoresizingMaskIntoConstraints = false
        shieldImageView.size(CGSize(width: 77, height: 87))
        shieldParent.addSubview(shieldImageView)
        shieldImageView.center(in: shieldParent)
        let messageParent = UIView()
        let messageLabel = UILabel.posterTextLabelBicolor(text: L.Profile.YouAreLoggedIn.localization, primary: L.Profile.YouAreLoggedIn.localization, alignment: .center)
        messageParent.addSubview(messageLabel)
        messageLabel.edges(to: messageParent)

        let lowerSpace = UIView()
        
        let OkButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.OKButton.localization)
        
        // the stackView
        let stack = BasicStackView(arrangedSubviews: [posterParent, upperspace, shieldParent, messageParent, lowerSpace, OkButton])
        view.addSubview(stack)
        
        //constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        upperspace.height(to: lowerSpace)
        shieldParent.height(88)
        OkButton.width(to: stack, offset: -24)
        posterParent.width(to: stack)
        
        // actions
        OkButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
    }
    
    @objc
    func confirmAction() {
        delegate?.confirmViewControllerDismiss(viewController: self)
    }
}
