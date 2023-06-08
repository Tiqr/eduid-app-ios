import UIKit
import TinyConstraints

class CreateEduIDCreatedViewController: CreateEduIDBaseViewController {

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .eduIDCreatedScreen
        setupUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //MARK: - setup ui
    func setupUI() {
        
        //poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabel(text: "Your eduID has been created")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // text label
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
To safely use this app, we need you to set a pincode and provide a phonenumber in case you might forget it.
"""
                                                         , partBold: "")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // image
        let imageParent = UIView()
        let imageView = UIImageView(image: R.image.eduid_created_image())
        imageView.contentMode = .scaleAspectFit
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // buttons
        let continueButton = EduIDButton(type: .primary, buttonTitle: "Continue")
        
        // stack
        let stack = BasicStackView(arrangedSubviews: [posterParent, textParent, imageParent, continueButton])
        view.addSubview(stack)
        
        // constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        imageView.width(to: view)
        imageParent.width(to: stack)
        imageView.width(to: view)
        posterParent.width(to: stack)
        continueButton.width(to: stack, offset: -24)
        
        // actions
        continueButton.addTarget(self, action: #selector(authorize), for: .touchUpInside)
    }
    
    @objc
    func authorize() {
        AppAuthController.shared.authorize(viewController: self)
        showNextScreen()
    }

}
