import UIKit
import TinyConstraints

class AlertMessageViewController: BaseViewController {

    var stack = BasicStackView(arrangedSubviews: [])
    
    let textMessage: String
    let buttonTitle: String
    
    let actionClosure: (() -> Void)?
    
    //MARK: - init
    init(textMessage: String, buttonTitle: String, actionClosure: (() -> Void)?) {
        self.textMessage = textMessage
        self.buttonTitle = buttonTitle
        self.actionClosure = actionClosure
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        stack.alignment = .center
        
        let imageView = UIImageView(image: .shield)
        imageView.size(CGSize(width: 77, height: 87))
        imageView.contentMode = .scaleAspectFit
        
        let posterParent = UIView()
        let posterMessageLabel = UILabel.posterTextLabelBicolor(text: textMessage, primary: textMessage, alignment: .center)
        posterParent.addSubview(posterMessageLabel)
        posterMessageLabel.edges(to: posterParent)
        
        let upperSapce = UIView()
        let lowerSpace = UIView()
        
        let confirmButton = EduIDButton(type: .primary, buttonTitle: buttonTitle)
        confirmButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        stack.addArrangedSubview(upperSapce)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(posterParent)
        stack.addArrangedSubview(lowerSpace)
        stack.addArrangedSubview(confirmButton)
        
        view.addSubview(stack)
        
        // constraints
        lowerSpace.height(to: upperSapce)
        stack.edgesToSuperview(insets: .uniform(24), usingSafeArea: true)
        confirmButton.width(to: stack, offset: -24)
        posterParent.width(to: stack)
    
    }

    @objc
    func action() {
        actionClosure?()
    }
}
