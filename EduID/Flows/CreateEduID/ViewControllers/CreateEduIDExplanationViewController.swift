import UIKit
import TinyConstraints

class CreateEduIDExplanationViewController: CreateEduIDBaseViewController {
    
    private var stack: AnimatedVStackView!
    private let createButton = EduIDButton(type: .primary, buttonTitle: L.CreateEduID.Explanation.CreateEduidButton.localization)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        createButton.isUserInteractionEnabled = true
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - create Label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabel(text: L.CreateEduID.Explanation.MainTitleLabel.localization, size: 24)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: L.CreateEduID.Explanation.MainExplanationText.localization, partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        //the action for this buton is defined in superclass
        createButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        // - spacing
        let spacerView = UIView()
        
        // - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textLabelParent, spacerView, createButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        // - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.width(to: stack)
        createButton.width(to: stack, offset: -24)
        
        textLabel.width(to: stack, offset: -32)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
}
