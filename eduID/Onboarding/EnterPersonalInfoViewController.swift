import UIKit
import TinyConstraints

class EnterPersonalInfoViewController: EduIDBaseViewController, ValidatedTextFieldDelegate {
    
    let requestButton = EduIDButton(type: .primary, buttonTitle: "Request you eduID")
    
    var validationMap: [Int: Bool] = [0:false, 1:false, 2: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            requestButton.isEnabled = isTrue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        //MARK: - poster text
        let posterLabel = UILabel.posterTextLabel(text: "Request your eduID", size: 24)
        
        //MARK: - email
        let emailField = EduIDValidatedTextStackView(title: "Your email address", placeholder: "e.g. timbernerslee@gmail.com", keyboardType: .default)
        emailField.tag = 0
        emailField.delegate = self
        
        //MARK: - firstname
        let firstNameField = EduIDValidatedTextStackView(title: "First name", placeholder: "e.g. Tim", keyboardType: .default)
        firstNameField.tag = 1
        firstNameField.delegate = self
        
        //MARK: - lastName
        let lastNameField = EduIDValidatedTextStackView(title: "Last name", placeholder: "e.g. Berners-Lee", keyboardType: .default)
        lastNameField.tag = 2
        lastNameField.delegate = self
        
        //MARK: - check terms
        let termsHstack = UIStackView()
        termsHstack.spacing = 10
        termsHstack.axis = .horizontal
        termsHstack.height(36)
        
        let theSwitch = UISwitch()
        theSwitch.tintColor = .primaryColor
        let termsLabel = UILabel()
        termsLabel.font = .sourceSansProRegular(size: 12)
        termsLabel.textColor = .charcoal
        termsLabel.numberOfLines = 2
        termsLabel.text = "I agree with the terms of service. I also understand the privacy policy."
        
        termsHstack.addArrangedSubview(theSwitch)
        termsHstack.addArrangedSubview(termsLabel)
        
        //MARK: - spacing
        let spacingView = UIView()
        
        //MARK: - requestButton
        requestButton.isEnabled = false
        requestButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, emailField, firstNameField, lastNameField, termsHstack, spacingView, requestButton])
        stack.spacing = 32
        stack.setCustomSpacing(0, after: emailField)
        stack.setCustomSpacing(0, after: firstNameField)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .top
        
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)
        
        horizontalEdgesToView(aView: requestButton, offset: 48)
        
        horizontalEdgesToView(aView: emailField, offset: 32)
        horizontalEdgesToView(aView: firstNameField, offset: 32)
        horizontalEdgesToView(aView: lastNameField, offset: 32)
    }
    
    //MARK: - Textfield delegate
    
    func updateValidation(with value: Bool, from tag: Int) {
        validationMap[tag] = value
    }
    
    @objc
    private func tapped() {
        navigationController?.pushViewController(CheckEmailViewController(), animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
}
