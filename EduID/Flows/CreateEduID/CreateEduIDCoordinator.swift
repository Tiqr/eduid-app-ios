import UIKit
import TiqrCoreObjC

final class CreateEduIDCoordinator: CoordinatorType {
    
    public static var userdefaultsOnboardingTypeKey = "userdefaultsOnboardingTypeKey"
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController!
    weak var delegate: CreateEduIDCoordinatorDelegate?
    
    var children: [CoordinatorType] = []
    
    // state variable to keep track of the current screen in the flow
    var currentScreenType: ScreenType = .landingScreen
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
        NotificationCenter.default.addObserver(self, selector: #selector(startExistingUserWithoutSecretFlow), name: .firstTimeAuthorizationComplete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startExistingUserWithSecretFlow), name: .firstTimeAuthorizationCompleteWithSecretPresent, object: nil)
        let navigationController = UINavigationController()
        navigationController.isModalInPresentation = true
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController = navigationController
        viewControllerToPresentOn?.present(self.navigationController, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - start
    func startWithLanding() {
        let landingScreen = CreateEduIDLandingPageViewController()
        landingScreen.delegate = self
        navigationController.setViewControllers([landingScreen], animated: false)
    }
    
    @objc func startExistingUserWithoutSecretFlow() {
        currentScreenType = .redirect
        createEduIDViewControllerShowNextScreen(viewController: UIViewController())
    }
    
    @objc func startExistingUserWithSecretFlow() {
        currentScreenType = .smsChallengeScreen
        createEduIDViewControllerShowNextScreen(viewController: UIViewController())
    }
}

extension CreateEduIDCoordinator: ScanCoordinatorDelegate {
    
    func scanCoordinatorDismissScanScreen(coordinator: ScanCoordinator) {
        navigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
    
    func scanCoordinatorJumpToCreatePincodeScreen(coordinator: ScanCoordinator, viewModel: ScanViewModel) {
        guard let challenge = viewModel.challenge as? EnrollmentChallenge else {
            return
        }
        // Enrolment started from QR
        ScreenType.isQrEnrolment = true
        let pincodeFirstAttemptViewController = CreatePincodeFirstEntryViewController(
            viewModel: CreatePincodeAndBiometricAccessViewModel(
                enrollmentChallenge: challenge
            )
        )
        
        pincodeFirstAttemptViewController.delegate = self
        navigationController.pushViewController(pincodeFirstAttemptViewController, animated: true)
    }
}

extension CreateEduIDCoordinator: CreateEduIDViewControllerDelegate {
    
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: navigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start()
    }
    
    //MARK: - show next screen
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController) {
        if currentScreenType == .addInstitutionScreen {
            delegate?.createEduIDCoordinatorDismissOnBoarding(coordinator: self)
            
            // - write onboarding flow state to user defaults
            UserDefaults.standard.set(OnboardingFlowType.onboard.rawValue, forKey: OnboardingManager.userdefaultsFlowTypeKey)
            return
        }
        
        if currentScreenType == .welcomeScreen &&
            ServiceContainer.sharedInstance().identityService.identityCount() > 1 {
            // No need to ask for school details, the user has already seen the question once.
            delegate?.createEduIDCoordinatorDismissOnBoarding(coordinator: self)
            return
        }
        
        // - this is the end of the onboarding in case the user has scanned the enrollment qr from the web
        if let onboardingTypeString = UserDefaults.standard.value(forKey: OnboardingManager.userdefaultsFlowTypeKey) as? String, OnboardingFlowType(rawValue: onboardingTypeString) == .mfaOnly {
            if currentScreenType == .biometricApprovalScreen {
                
                // - signal the coordinator to end the create flow
                delegate?.createEduIDCoordinatorDismissOnBoarding(coordinator: self)
                
                // - write onboarding flow state to user defaults
                UserDefaults.standard.set(OnboardingFlowType.onboard.rawValue, forKey: OnboardingManager.userdefaultsFlowTypeKey)
                
                return
            }
        }
        
        guard let navController = navigationController, let nextViewController = currentScreenType.nextCreateEduIDScreen().viewController() else {
            return
            
        }
        (nextViewController as? CreateEduIDBaseViewController)?.delegate = self
        (nextViewController as? CreateEduIDEnterPersonalInfoViewController)?.delegate = self
        navController.pushViewController(nextViewController, animated: true)
        currentScreenType = currentScreenType.nextCreateEduIDScreen()
    }
    
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let createPincodeSecondEntryViewController = CreatePincodeSecondEntryViewController(viewModel: viewModel)
        createPincodeSecondEntryViewController.delegate = self
        navigationController.pushViewController(createPincodeSecondEntryViewController, animated: true)
        currentScreenType = .createPincodeSecondEntryScreen
    }
    
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let biometricViewController = BiometricAccessApprovalViewController(viewModel: viewModel)
        biometricViewController.delegate = self
        biometricViewController.biometricApprovaldelegate = self
        navigationController.pushViewController(biometricViewController, animated: true)
        currentScreenType = .biometricApprovalScreen
    }
    
    func createEduIDViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController) {
        navigationController.popToViewController(navigationController.viewControllers.first { $0 is CreatePincodeFirstEntryViewController}!, animated: true)
        let alert = UIAlertController(title: L.PinAndBioMetrics.RetryPin.localization, message: L.PinAndBioMetrics.EnteredPinNotEqual.localization, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { action in
            // no action
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.navigationController.present(alert, animated: true)
        })
    }

    @objc
    func goBack(viewController: UIViewController) {
        navigationController.popViewController(animated: true)
        currentScreenType = (navigationController.topViewController as? BaseViewController)?.screenType ??
            ScreenType(rawValue: max(0, currentScreenType.rawValue - 1)) ?? .none
    }
}

extension CreateEduIDCoordinator: BiometricApprovalViewControllerDelegate {
}

