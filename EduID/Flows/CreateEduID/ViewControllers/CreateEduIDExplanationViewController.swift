import UIKit
import TinyConstraints

class CreateEduIDExplanationViewController: CreateEduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .explanationScreen
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - create Label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabel(text: "Don't have an eduID yet?", size: 24)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
eduID is a central account for users\nassociated with Dutch education and\nresearch. It is yours and exists independent\nof an educational institution.\n\n• Use it to login to several services connected to SURFconext.\n• Users without an institution account can also request an eduID.\n• eduID is a lifelong account. It stays validafter you graduate.
"""
                                                         , partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        // - create button
        let button = EduIDButton(type: .primary, buttonTitle: "Create a new eduID")
        
        //the action for this buton is defined in superclass
        button.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        // - spacing
        let spacerView = UIView()
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textLabelParent, spacerView, button])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.width(to: stack)
        button.width(to: stack, offset: -24)
        
        textLabel.width(to: stack, offset: -32)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
}
