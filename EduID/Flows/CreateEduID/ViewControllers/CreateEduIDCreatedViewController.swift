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
        let posterLabel = UILabel.posterTextLabel(text: L.CreatEduID.Created.MainTitleLabel.localization)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // text label
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: L.CreatEduID.Created.MainText.localization, partBold: "")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // image
        let imageParent = UIView()
        let imageView = UIImageView(image: .eduIDCreatedImage)
        imageView.contentMode = .scaleAspectFit
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // buttons
        let continueButton = EduIDButton(type: .primary, buttonTitle: L.NameUpdated.Continue.localization)
        
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
