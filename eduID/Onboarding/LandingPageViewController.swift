import UIKit
import TinyConstraints

class LandingPageViewController: UIViewController {
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        navigationItem.titleView = logo
        
        setupUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextScreen)))
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        //MARK: - add logo
        let logo = UIImageView(image: .eduIDLogo)
        logo.height(60)
        logo.width(150)
        
        //MARK: - add label
        let posterLabel = UILabel.posterTextLabel(text: "Personal account\nfor Education and Research", size: 24)
        
        //MARK: add image
        let imageView = UIImageView(image: .landingPageImage)
        imageView.contentMode = .scaleAspectFit
        imageView.height(252)
        imageView.width(141)
        
        //MARK: buttons
        let signinButton = EduIDButton(type: .primary, buttonTitle: "Sign in")
        let scanQRButton = EduIDButton(type: .primary, buttonTitle: "Scan a QR code")
        let noEduIDYetButton = EduIDButton(type: .naked, buttonTitle: "I don't have an eduId")
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [logo, posterLabel, imageView, signinButton, scanQRButton, noEduIDYetButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        horizontalEdgesToView(aView: signinButton, offset: 48)
        horizontalEdgesToView(aView: scanQRButton, offset: 48)
        horizontalEdgesToView(aView: noEduIDYetButton, offset: 48)
        horizontalEdgesToView(aView: posterLabel, offset: 48)
    }
    
    @objc
    private func nextScreen() {
        navigationController?.pushViewController(CreateEduIDLandingPageViewController(), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    @objc
    private func backTapped() {
        navigationController?.popViewController(animated: true)
    }


}
