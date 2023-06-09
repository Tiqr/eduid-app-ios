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
            let onboardingCoordinator = CreateEduIDCoordinator(viewControllerToPresentOn: homeNavigationController)
            children.append(onboardingCoordinator)
            onboardingCoordinator.delegate = self
            onboardingCoordinator.start()
        }
    }
    
    func showActivityScreen() {}
}

extension MainCoordinator: HomeViewControllerDelegate  {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController) {
        let personalInfoCoordinator = PersonalInfoCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start()
    }
    
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController) {
        let securityCoordinator = SecurityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start()
    }
    
    func homeViewControllerShowActivityScreen(viewController: HomeViewController) {
        let activityCoordinator = ActivityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(activityCoordinator)
        activityCoordinator.delegate = self
        activityCoordinator.start()
    }
    
    func homeViewControllerShowScanScreen(viewController: HomeViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: homeNavigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(for: .login)
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
        // not implemented
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
