import UIKit
import TinyConstraints

class OnboardingSuccessViewController: EduIDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(qrTapped))
    }
    
    func setupUI() {
        //MARK: - PosterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your eduID app\nis ready for use", size: 32, primary: "Your eduID app")
        view.addSubview(posterLabel)
        posterLabel.width(to: view)
        posterLabel.centerX(to: view)
        posterLabel.top(to: view, offset: 125)
        
        //MARK: - blue bottom view
        let blueBottomView = UIView()
        blueBottomView.translatesAutoresizingMaskIntoConstraints = false
        blueBottomView.backgroundColor = .backgroundColor
        view.addSubview(blueBottomView)
        blueBottomView.width(to: view)
        blueBottomView.bottom(to: view)
        blueBottomView.height(236)
        
        //MARK: - image
        let image = UIImageView(image: .readyForUse)
        view.addSubview(image)
        image.width(to: view)
        image.aspectRatio(0.761)
        image.contentMode = .scaleAspectFit
        image.bottom(to: view, offset: -76)
        
        //MARK: - button stack
        let securityButton = UIButton()
        securityButton.setImage(.security, for: .normal)
        securityButton.size(CGSize(width: 51, height: 51))
        securityButton.addTarget(self, action: #selector(securityTapped), for: .touchUpInside)
        let securityLabel = UILabel()
        securityLabel.font = .nunitoBold(size: 14)
        securityLabel.text = "Security"
        securityLabel.textAlignment = .center
        securityLabel.width(100)
        securityLabel.textColor = .white
        let firstVStack = UIStackView(arrangedSubviews: [securityButton, securityLabel])
        firstVStack.axis = .vertical
        firstVStack.width(100)
        firstVStack.spacing = 3
        
        let personalInfoButton = UIButton()
        personalInfoButton.setImage(.personalInfo, for: .normal)
        personalInfoButton.size(CGSize(width: 51, height: 51))
        personalInfoButton.addTarget(self, action: #selector(personalInfoTapped), for: .touchUpInside)
        let personalInfoLabel = UILabel()
        personalInfoLabel.font = .nunitoBold(size: 14)
        personalInfoLabel.text = "Personal info"
        personalInfoLabel.textAlignment = .center
        personalInfoLabel.textColor = .white
        let secondVStack = UIStackView(arrangedSubviews: [personalInfoButton, personalInfoLabel])
        secondVStack.axis = .vertical
        secondVStack.width(100)
        secondVStack.spacing = 3
        
        let activityButton = UIButton()
        activityButton.setImage(.activity, for: .normal)
        activityButton.size(CGSize(width: 51, height: 51))
        activityButton.addTarget(self, action: #selector(activityTapped), for: .touchUpInside)
        let activityLabel = UILabel()
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        activityLabel.font = .nunitoBold(size: 14)
        activityLabel.textColor = .white
        let thirdVStack = UIStackView(arrangedSubviews: [activityButton, activityLabel])
        thirdVStack.axis = .vertical
        thirdVStack.width(100)
        thirdVStack.spacing = 3
        
        let buttonStack = UIStackView(arrangedSubviews: [firstVStack, secondVStack, thirdVStack])
        buttonStack.spacing = 0
        view.addSubview(buttonStack)
        buttonStack.centerX(to: view)
        buttonStack.bottom(to: view, offset: -60)
        buttonStack.height(100)
        
    }
    
    //MARK: - QR icon in navbar tapped
    @objc
    func qrTapped() {
        
    }
    
    //MARK: - action buttons
    
    @objc
    func securityTapped() {
        
    }
    
    @objc
    func personalInfoTapped() {
        
    }
    
    @objc
    func activityTapped() {
        
    }
}
