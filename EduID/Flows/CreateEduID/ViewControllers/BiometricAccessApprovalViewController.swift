import UIKit
import TinyConstraints

class BiometricAccessApprovalViewController: CreateEduIDBaseViewController {
    
    weak var biometricApprovaldelegate: BiometricApprovalViewControllerDelegate?
    let createPincodeViewModel: CreatePincodeAndBiometricAccessViewModel
    private let biometricService = BiometricService()
    
    //MARK: - init
    init(viewModel: CreatePincodeAndBiometricAccessViewModel) {
        self.createPincodeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.createPincodeViewModel.nextScreenDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .biometricApprovalScreen
        setupUI()
    }
    
    //MARK: - setup ui
    func setupUI() {
        //poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabel(text: "Biometric approval")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // text label
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
Do you want to use your biometrics to access the eduID app more easily?
"""
                                                         , partBold: "biometrics")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // image
        let imageParent = UIView()
        let imageView = UIImageView(image: R.image.biometric_image())
        imageView.aspectRatio(1 / 0.727564102564103)
        imageView.contentMode = .scaleAspectFit
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // buttons
        let setupButton = EduIDButton(type: .primary, buttonTitle: "Set up biometric access")
        let skipButton = EduIDButton(type: .ghost, buttonTitle: "Skip this")
        
        // stack
        let stack = BasicStackView(arrangedSubviews: [posterParent, textParent, imageParent, setupButton, skipButton])
        view.addSubview(stack)
        
        // constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        imageView.width(to: view)
        imageParent.width(to: stack)
        imageView.width(to: view)
        posterParent.width(to: stack)
        setupButton.width(to: stack, offset: -24)
        skipButton.width(to: stack, offset: -24)
        
        // actions
        setupButton.addTarget(createPincodeViewModel, action: #selector(createPincodeViewModel.requestBiometricAccess), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(promptSkipBiometricAccess), for: .touchUpInside)
    }
    
    @objc func promptSkipBiometricAccess() {
            let alert = UIAlertController(title: Constants.AlertTiles.skipUsingBiometricsTitle, message: Constants.AlertMessages.skipUsingBiometricsMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: Constants.ButtonTitles.proceed, style: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.nextScreen(for: self.createPincodeViewModel.enrollmentChallenge != nil ? .registerWithoutRecovery : .none)
                })
            alert.addAction(UIAlertAction(title: Constants.ButtonTitles.cancel, style: .cancel) { action in
                alert.dismiss(animated: true)
            })
            present(alert, animated: true)
    }
    
}

extension BiometricAccessApprovalViewController: ShowNextScreenDelegate {
    func nextScreen(for type: NextScreenFlowType) {
        switch type {
        case .registerWithoutRecovery: self.dismiss(animated: true)
        default:
            (self.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
        }
    }
}
