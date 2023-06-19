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
        let posterLabel = UILabel.posterTextLabel(text: L.CreateEduID.Explanation.MainTitleLabel.localization, size: 24)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: L.CreateEduID.Explanation.MainExplanationText.localization, partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        // - create button
        let button = EduIDButton(type: .primary, buttonTitle: L.CreateEduID.Explanation.CreateEduidButton.localization)
        
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
