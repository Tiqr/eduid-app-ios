import UIKit
import TinyConstraints

class ReviewViewController: EduIDBaseViewController {

    //MARK: - verify button
    let continueButton = EduIDButton(type: .primary, buttonTitle: "Verify this phone number")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your school/uni\nwas contacted successfully", size: 24, primary: "Your school/uni")
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
The following information has been added to your eduID and can now be shared.
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        textView.attributedText = attributedText
        
        //MARK: institution views
        let firstInstitution = InstitutionView(title: "full name", firstText: "R. van Hamersdonksveer", secondText: "Provided by Universiteit van Amsterdam", action: {})
        let secondInstitution = InstitutionView(title: "Proof of being a student", firstText: "🧑‍🎓 Student", secondText: "Provided by Universiteit van Amsterdam", action: {})
        let thirdInstitution = InstitutionView(title: "Your institution", firstText: "‍🏛️ Universiteit van Amsterdam", secondText: "Provided by Universiteit van Amsterdam", action: {})
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textView, firstInstitution, secondInstitution, thirdInstitution, spaceView, continueButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        posterLabel.width(to: stack)
        firstInstitution.width(to: stack)
        secondInstitution.width(to: stack)
        thirdInstitution.width(to: stack)
        textView.height(60)
        posterLabel.height(68)
        continueButton.width(to: stack)
    }
    
    @objc
    func continueTapped() {
        navigationController?.pushViewController(OnboardingSuccessViewController(), animated: true)
    }

}
