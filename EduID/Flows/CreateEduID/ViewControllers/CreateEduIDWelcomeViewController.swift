import UIKit
import TinyConstraints

class CreateEduIDWelcomeViewController: CreateEduIDBaseViewController {
    
    // - attributed texts for numbered list
    var attributedTexts: [NSAttributedString] = []

    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .welcomeScreen
        
        let first = NSMutableAttributedString(string: "Quickly login to educational services", attributes: [.font: UIFont.sourceSansProRegular(size: 16)])
        first.setAttributes([.font: UIFont.sourceSansProBold(size: 16)], range: NSRange(location: 0, length: 13))
       let second = NSMutableAttributedString(string: "View what details of your eduID get shared with those services", attributes: [.font: UIFont.sourceSansProRegular(size: 16)])
        second.setAttributes([.font: UIFont.sourceSansProBold(size: 16)], range: NSRange(location: 0, length: 4))
        let third = NSMutableAttributedString(string: "Verify your identity so you can access more secure services.", attributes: [.font: UIFont.sourceSansProRegular(size: 16)])
        third.setAttributes([.font: UIFont.sourceSansProBold(size: 16)], range: NSRange(location: 0, length: 20))
        attributedTexts.append(contentsOf: [first, second, third])

        setupUI()
    }
    
    //MARK: setup UI
    func setupUI() {
        // - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Welcome! Use this app to", size: 24)
        
        // - numbered list stack
        let numstack = UIStackView()
        numstack.axis = .vertical
        (1...3).forEach { integerIndex in
           
            let numberLabel = UILabel()
            numberLabel.font = .sourceSansProBold(size: 44)
            numberLabel.textColor = .primaryColor
            numberLabel.text = "\(integerIndex)"
            numberLabel.width(30)
            
            let messageLabel = UILabel()
            messageLabel.numberOfLines = 0
            messageLabel.attributedText = attributedTexts[integerIndex - 1]
            
            let hStack = UIStackView(arrangedSubviews: [numberLabel, messageLabel])
            hStack.spacing = 10
            numstack.addArrangedSubview(hStack)
        }
        
        // - image
        let image = UIImageView(image: .welcomeInstructions)
        image.contentMode = .scaleAspectFit
        image.width(150)
        image.height(150)
        
        // - ok button
        let okButton = EduIDButton(type: .primary, buttonTitle: "Ok, Got it!")
        okButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        // - Space
        let spaceView = UIView()
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, numstack, image, spaceView, okButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        posterLabel.height(34)
        okButton.width(to: stack, offset: -24)
    }
}
