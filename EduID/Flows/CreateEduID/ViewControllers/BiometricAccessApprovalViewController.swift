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
        let posterLabel = UILabel.posterTextLabel(text: L.PinAndBioMetrics.BiometricsApproval.localization)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        // text label
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: L.PinAndBioMetrics.BiometricsExplain.localization
                                                         , partBold: L.PinAndBioMetrics.BiometricsExplainBoldPart.localization)
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        // image
        let imageParent = UIView()
        let imageView = UIImageView(image: .biometric)
        imageView.aspectRatio(1 / 0.727564102564103)
        imageView.contentMode = .scaleAspectFit
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // buttons
        let setupButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.SetupBiometrics.localization)
        let skipButton = EduIDButton(type: .ghost, buttonTitle: L.CreateEduID.FirstTimeDialog.SkipButtonTitle.localization)
        
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
        let alert = UIAlertController(title: L.PinAndBioMetrics.SkipAlertTitle.localization, message: L.PinAndBioMetrics.SkipAlertText.localization, preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: L.Profile.RemoveServicePrompt.Cancel.localization, style: .destructive) { _ in
                    alert.dismiss(animated: true)
                })
        alert.addAction(UIAlertAction(title: L.Profile.Proceed.localization, style: .cancel) { [weak self] action in
            guard let self else { return }
            self.nextScreen()
            })
            present(alert, animated: true)
    }
    
}

extension BiometricAccessApprovalViewController: ShowNextScreenDelegate {
    func nextScreen() {
        (self.biometricApprovaldelegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}
