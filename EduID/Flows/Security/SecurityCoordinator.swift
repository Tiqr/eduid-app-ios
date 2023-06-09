import UIKit

class SecurityCoordinator: CoordinatorType, SecurityViewControllerDelegate {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var delegate: SecurityCoordinatorDelegate?
    weak var navigationController: UINavigationController?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }

    //MARK: - start
    func start() {
        let securityLandingViewController = SecurityLandingViewController()
        securityLandingViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: securityLandingViewController)
        self.navigationController = navigationController
        navigationController.isModalInPresentation = true
        
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
    
    func goBack(viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func securityViewControllerDismissSecurityFlow(viewController: UIViewController) {
        delegate?.securityCoordinatorDismissSecurityFlow(coordinator: self)
    }
    
    //MARK: - verify email flow
    
    func securityViewController(viewController: UIViewController, verify email: String) {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.delegate = self
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func securityViewControllerEnterVerifyEmailFlow(viewController: UIViewController) {
        let emailViewController = SecurityEnterEmailViewController()
        emailViewController.delegate = self
        navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    //MARK: - change password flow
    
    func securityViewControllerEnterChangePasswordFlow(viewController: UIViewController) {
        let changePasswordViewController = SecurityChangePasswordViewController(viewModel: ChangePasswordViewModel())
        changePasswordViewController.delegate = self
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    func securityViewController(viewController: UIViewController, reset password: String) {
        let confirmViewController = AlertMessageViewController(textMessage: "Password changed succefully", buttonTitle: "Ok") { [weak self] in
            if let self = self {
                self.securityGotoRootViewController(sender: self.navigationController!)
            }
        }
        navigationController?.pushViewController(confirmViewController, animated: true)
    }
    
    func securityGotoRootViewController(sender: AnyObject) {
        navigationController?.popToRootViewController(animated: true)
    }
}

