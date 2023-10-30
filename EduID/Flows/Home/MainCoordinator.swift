import UIKit
import TinyConstraints

class MainCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    var protectionViewLayer: UIView?
    private let biometricService = BiometricService()
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        self.homeNavigationController = homeNavigationController
        homeViewController.delegate = self
    }
    
    func start(option: OnboardingFlowType) {
        if option == .newUser {
            AppAuthController.shared.clearAuthState()
            let onboardingCoordinator = CreateEduIDCoordinator(viewControllerToPresentOn: homeNavigationController)
            children.append(onboardingCoordinator)
            onboardingCoordinator.delegate = self
            onboardingCoordinator.startWithLanding()
        }
    }
    
    func showActivityScreen() {}
}

extension MainCoordinator: HomeViewControllerDelegate  {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController, loadData: Bool, animated: Bool) {
        let personalInfoCoordinator = PersonalInfoCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start(refreshDelegate: viewController, loadData: loadData, animated: animated)
    }
    
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController, animated: Bool) {
        let securityCoordinator = SecurityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start(refreshDelegate: viewController, animated: animated)
    }
    
    func homeViewControllerShowActivityScreen(viewController: HomeViewController, animated: Bool) {
        let activityCoordinator = ActivityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(activityCoordinator)
        activityCoordinator.delegate = self
        activityCoordinator.start(refreshDelegate: viewController, animated: animated)
    }
    
    func homeViewControllerShowScanScreen(viewController: HomeViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: homeNavigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(for: .login)
    }
    
    func homeViewControllerShowAuthenticationScreen(with payload: String) {
        let verifyAuthenticationCoordinator = VerifyAuthenticationCoordinator(viewControllerToPresentOn: homeNavigationController)
        verifyAuthenticationCoordinator.delegate = self
        children.append(verifyAuthenticationCoordinator)
        verifyAuthenticationCoordinator.start(with: payload)
    }

}

//MARK: - personal info methods
extension MainCoordinator: PersonalInfoCoordinatorDelegate {

    func personalInfoCoordinatorDismissPersonalInfoFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

    
//MARK: - scan screen methods
extension MainCoordinator: ScanCoordinatorDelegate {
    
    func scanCoordinatorJumpToCreatePincodeScreen(coordinator: ScanCoordinator, viewModel: ScanViewModel) {
        // Our responsibility stops here, and we delegate to the eduID coordinator, which will continue with the flow
        homeNavigationController.popToRootViewController(animated: false)
        let eduidCoordinator = CreateEduIDCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(eduidCoordinator)
        eduidCoordinator.scanCoordinatorJumpToCreatePincodeScreen(coordinator: coordinator, viewModel: viewModel)
    }
    
    func scanCoordinatorDismissScanScreen(coordinator: ScanCoordinator) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - security screen flow
extension MainCoordinator: SecurityCoordinatorDelegate {

    func securityCoordinatorDismissSecurityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}
 
//MARK: - onboarding delegate
extension MainCoordinator: CreateEduIDCoordinatorDelegate {
    
    func createEduIDCoordinatorDismissOnBoarding(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - activity flow methods
extension MainCoordinator: ActivityCoordinatorDelegate {
    func activityCoordinatorDismissActivityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - activity flow methods
extension MainCoordinator: VerifyAuthenticationDelegate {
    func verifyAuthenticationCoordinatorDismissActivityFlow(coordinator: CoordinatorType) {
        homeNavigationController.popViewController(animated: true)
        children.removeAll { $0 === coordinator }
        // An auth flow has just ended. If we also have a token, we can check if there's a pending screen to open
        if AppAuthController.shared.isLoggedIn() {
            if let homeViewController = homeNavigationController.topViewController as? HomeViewController {
                homeViewController.openPendingScreen(animated: true)
            }
        }
    }
}
