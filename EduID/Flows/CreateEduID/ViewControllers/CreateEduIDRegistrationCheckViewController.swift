import UIKit
import TinyConstraints
import Combine

enum RegistrationCheckAlertMode {
    case error, deactivate
}

class CreateEduIDRegistrationCheckViewController: CreateEduIDBaseViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let viewModel: CreateEduIDRegistrationCheckViewModel = .init()
    private var cancellable : Set<AnyCancellable> = .init()
    private var shouldShowNextScreen: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AppAuthController.shared.isLoggedIn() {
            Task {
                await viewModel.checkForAnyExistingUser()
                await MainActor.run {
                    setupObservers()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    private func setupObservers() {
        viewModel.isExistingUserPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isExistingUser in
                guard let self else { return }
                if isExistingUser {
                    self.presentAlert(with: L.Security.Tiqr.AlreadyEnrolledTitle.localization,
                                 and: L.Security.Tiqr.AlreadyEnrolledText.localization,
                                 mode: .deactivate)
                } else {
                    if self.shouldShowNextScreen {
                        self.shouldShowNextScreen = false
                        self.showNextScreen()
                    }
                }
            }.store(in: &cancellable)
        
        viewModel.shouldDisplayErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error {
                    self?.presentAlert(with: error.eduIdResponseError().title,
                                 and: error.eduIdResponseError().message,
                                 mode: .error)
                }
            }.store(in: &cancellable)
    }
    
    private func setupUI() {
        let label = UILabel.posterTextLabelBicolor(frame: nil, text: L.RegistrationCheck.MainText.localization,
                                                   size: 24, primary: L.RegistrationCheck.HighLight.localization)
        view.addSubview(label)
        view.addSubview(activityIndicator)
        activityIndicator.center(in: view)
        label.top(to: view, offset: 150)
        label.leading(to: view, offset: 24)
        label.trailing(to: view, offset: -24)
    }
    
    private func presentAlert(with title: String, and message: String, mode: RegistrationCheckAlertMode) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L.Profile.RemoveServicePrompt.Cancel.localization, style: .cancel) { [weak self] _ in
            if mode == .deactivate {
                UserDefaults.standard.set(OnboardingFlowType.existingUserWithSecret.rawValue, forKey: OnboardingManager.userdefaultsFlowTypeKey)
                self?.dismiss(animated: true)
            } else {
                alertController.dismiss(animated: true)
            }
        }
        
        let deactivate = UIAlertAction(title: L.Security.Tiqr.Deactivate.localization, style: .destructive) { [weak self] _ in
            let smsVerification = CreateEduIDEnterSMSViewController(viewModel: PinViewModel(), isSecure: false)
            smsVerification.modalPresentationStyle = .fullScreen
            smsVerification.isDeactivationMode = true
            self?.present(smsVerification, animated: true)
        }
        
        switch mode {
        case .deactivate:
            alertController.addAction(deactivate)
            alertController.addAction(cancelAction)
        case .error: alertController.addAction(cancelAction)
        }
        
        present(alertController, animated: true)
    }
}
