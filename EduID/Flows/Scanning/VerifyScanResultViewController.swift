import UIKit
import TiqrCoreObjC
import TinyConstraints

class VerifyScanResultViewController: BaseViewController {
    
    let viewModel: ScanViewModel
    weak var delegate: VerifyScanResultViewControllerDelegate?
    private var dismissVerifyAuthentication: (() -> Void)?
    private var mainStack = BasicStackView(arrangedSubviews: .init())

    //MARK: - init
    init(viewModel: ScanViewModel, dismissVerifyAuthentication: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.dismissVerifyAuthentication = dismissVerifyAuthentication
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .verifyLoginScreen
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenType.configureNavigationItem(item: navigationItem)
    }
    
    private func requestLoginLabel(entityName: String, challengeType: TIQRChallengeType) -> UILabel {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 16
    
        let labelString = L.PinAndBioMetrics.DoYouWantToLogInTo.localization
        let entityNameWithQuestionMark = "\(entityName)?"
        
        let attributedString = NSMutableAttributedString(string: "\(labelString)\n\(entityNameWithQuestionMark)", attributes: [.font: UIFont.sourceSansProSemiBold(size: 24), .foregroundColor: UIColor.primaryColor, .paragraphStyle: paragraphStyle])
        attributedString.setAttributeTo(part: entityNameWithQuestionMark, attributes: [.foregroundColor: UIColor.charcoalColor, .font: UIFont.sourceSansProSemiBold(size: 32), .paragraphStyle: paragraphStyle])
        let label = UILabel()
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    
    //MARK: - setupUI
    func setupUI() {
        // - top poster label
        let posterLabel = UILabel.posterTextLabelBicolor(
            text: L.PinAndBioMetrics.LoginRequest.localization,
            primary: L.PinAndBioMetrics.LoginRequest.localization
        )
        
        let upperspace = UIView()
        
        // - text in middle with organisation name
        let middlePosterParent = UIView()
        var middlePosterLabel = UILabel()
        
        switch viewModel.challengeType {
        case .enrollment:
            let challenge = viewModel.challenge as? EnrollmentChallenge
            middlePosterLabel = requestLoginLabel(
                entityName: challenge?.identityProviderDisplayName ?? challenge?.identityDisplayName ?? "",
                challengeType: viewModel.challengeType ?? .invalid
            )
        case .authentication:
            let challenge = viewModel.challenge as? AuthenticationChallenge
            middlePosterLabel = requestLoginLabel(
                entityName: challenge?.serviceProviderDisplayName ?? challenge?.serviceProviderIdentifier ?? "",
                challengeType: viewModel.challengeType ?? .invalid
            )
        default:
            break
        }
        
        middlePosterParent.addSubview(middlePosterLabel)
        middlePosterLabel.edges(to: middlePosterParent)
        
        let lowerSpace = UIView()
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.Modal.Cancel.localization)
        
        let primaryButton: EduIDButton
        
        switch viewModel.challengeType {
        case .authentication:
            primaryButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.SignIn.localization)
        case .enrollment:
            primaryButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.SignIn.localization)
        default:
            primaryButton = EduIDButton(type: .primary, buttonTitle: "")
        }

        let animatedHStack = AnimatedHStackView(arrangedSubviews: [cancelButton, primaryButton])
        animatedHStack.spacing = 24
        
        // - the stackView
        mainStack = BasicStackView(arrangedSubviews: [posterLabel, upperspace, middlePosterParent, lowerSpace, animatedHStack])
        view.addSubview(mainStack)
        
        // - constraints
        mainStack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        posterLabel.width(to: mainStack)
        upperspace.height(to: lowerSpace)
        animatedHStack.width(to: mainStack)
        primaryButton.width(to: cancelButton)
        
        // - actions:
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
        
    }
    
    //MARK: - button actions
    @objc func cancelAction() {
        let alert = UIAlertController(title: L.Profile.RemoveServicePrompt.Title.localization, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.RememberMe.Yes.localization, style: .cancel) { [weak self] action in
            guard let self = self else { return }
            if self.dismissVerifyAuthentication != nil {
                self.dismissView()
            } else {
                self.delegate?.verifyScanResultViewControllerCancelScanResult(viewController: self)
            }
        })
        alert.addAction(UIAlertAction(title: L.Modal.Cancel.localization, style: .default) { action in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    @objc func primaryAction() {
        switch viewModel.challengeType {
        case .enrollment:
            delegate?.verifyScanResultViewControllerEnroll(viewController: self, viewModel: viewModel)
        case .authentication:
            signIn()
        case .invalid, .none, .some(_):
            break
        }
    }
    
    private func signIn() {
        guard let challenge = viewModel.challenge as? AuthenticationChallenge,
        let identity = challenge.identity else { return }
        if identity.biometricIDEnabled == 1 {
            completeAuthentication(with: .biometrics)
        } else {
            presentPinCodeVerifyScreen()
        }
    }
    
    private func presentPinCodeVerifyScreen() {
        let pinCodeVC = VerifyPinCodeViewController()
        pinCodeVC.pinDelegate = self
        pinCodeVC.screenType = .pincodeScreen
        pinCodeVC.modalPresentationStyle = .fullScreen
        present(pinCodeVC, animated: true)
    }
    
    private func completeAuthentication(with mode: SecretVerificationMode, and pin: String? = nil) {
        guard let challenge = viewModel.challenge as? AuthenticationChallenge,
              let identity = challenge.identity else { return }
        switch mode {
        case .biometrics:
            ServiceContainer.sharedInstance().secretService.secret(for: identity, touchIDPrompt: L.PinAndBioMetrics.BiometricsPrompt.localization) { [weak self] data in
                guard let self else { return }
                if let secretData = data {
                    self.authenticate(with: secretData, and: challenge)
                }
            } failureHandler: { failed in
                self.presentPinCodeVerifyScreen()
            }
        case .pin:
            guard let pinCode = pin else { return }
            let secretData = ServiceContainer.sharedInstance().secretService.secret(for: identity, withPIN: pinCode)
            authenticate(with: secretData, and: challenge)
        }
    }
    
    private func authenticate(with secretData: Data?, and challenge: AuthenticationChallenge) {
        guard let secret = secretData else {
            self.presentPinCodeErrorScreen(nil)
            return
        }
        ServiceContainer.sharedInstance().challengeService.complete(challenge, withSecret: secret) { success, response, error in
            if success {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.updateUIAfterSigningIn()
                }
            } else if (error as NSError).code == TIQRACRConnectionError && !response.isEmpty {
                // Fallback to One-Time-Code
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.verifyScanResultViewControllerDisplayOneTimeCode(code: response, challenge: challenge)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.presentPinCodeErrorScreen(error as NSError)
                }
            }
        }
    }
    
    private func presentPinCodeErrorScreen(_ error: NSError?) {
        var title = (error?.userInfo[NSLocalizedDescriptionKey] as? String) ?? error?.domain ?? L.Generic.RequestError.Title.localization
        var description = (error?.userInfo[NSLocalizedFailureReasonErrorKey] as? String) ?? error?.localizedDescription ?? L.Generic.RequestError.Description(args: String(error?.code ?? 0)).localization
        if title == "unknown_error" {
            title = L.ResponseErrors.AuthenticationFailedTitle.localization
            description = L.ResponseErrors.AuthenticationFailedMessage.localization
        }
        let alert = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.Button.Back.localization, style: .default) { [weak self] _ in
            alert.dismiss(animated: true)
            self?.dismissView()
        })
        if error?.code == 303 {
            // Incorrect PIN
            alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.Button.Retry.localization, style: .default) { [weak self] _ in
                self?.presentPinCodeVerifyScreen()
            })
        }
        self.present(alert, animated: true)
    }
    
    private func updateUIAfterSigningIn() {
        mainStack.removeFromSuperview()
        let shieldImageFrame = CGRect(origin: .zero,
                                      size: CGSize(width: 100, height: 120))
        
        let shieldImageView = UIImageView(frame: shieldImageFrame)
        shieldImageView.image = .shield
        shieldImageView.contentMode = .scaleAspectFit
        
        let loggedInLabelFrame = CGRect(origin: .zero, size: CGSize(width: 320, height: 50))
        let loggedInLabel = UILabel.posterTextLabelBicolor(frame: loggedInLabelFrame,
                                                           text: L.Profile.YouAreLoggedIn.localization,
                                                           primary: L.Profile.YouAreLoggedIn.localization,
                                                           alignment: .center)
        
        let dismissButtonFrame = CGRect(origin: .zero, size: CGSize(width: 300, height: 48))
        let dismissButton = EduIDButton(type: .primary,
                                        buttonTitle: L.PinAndBioMetrics.OKButton.localization,
                                        frame: dismissButtonFrame)
        
        dismissButton.addTarget(self, action: #selector(dismissView),
                                for: .touchUpInside)
        
        let views = [shieldImageView,
                     loggedInLabel,
                     dismissButton]
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: $0.frame.width),
                $0.heightAnchor.constraint(equalToConstant: $0.frame.height),
            ])
        }
        
        NSLayoutConstraint.activate([
            shieldImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            shieldImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,
                                                     constant: -loggedInLabel.frame.height),
            
            loggedInLabel.topAnchor.constraint(equalTo: shieldImageView.bottomAnchor,
                                               constant: (loggedInLabel.frame.height / 2)),
            loggedInLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            dismissButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                  constant: -dismissButton.frame.height),
            dismissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc private func dismissView() {
        dismissVerifyAuthentication != nil
        ? dismissVerifyAuthentication?()
        : dismiss(animated: true)
    }
}

extension VerifyScanResultViewController: VerifyPinCodeDelegate {
    func get(pinCode: String) {
        completeAuthentication(with: .pin, and: pinCode)
    }
}

enum SecretVerificationMode {
    case pin, biometrics
}
