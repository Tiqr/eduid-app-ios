import UIKit
import OpenAPIClient
import TiqrCoreObjC

class SecurityCoordinator: CoordinatorType, SecurityViewControllerDelegate {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var delegate: SecurityCoordinatorDelegate?
    weak var navigationController: UINavigationController?
    
    private var pendingPersonalInfo: UserResponse? = nil
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }

    //MARK: - start
    func start(refreshDelegate: RefreshChildScreenDelegate, animated: Bool) {
        let securityOverviewViewController = SecurityOverviewViewController(viewModel: SecurityOverviewViewModel())
        securityOverviewViewController.delegate = self
        securityOverviewViewController.refreshDelegate = refreshDelegate
        let navigationController = UINavigationController(rootViewController: securityOverviewViewController)
        self.navigationController = navigationController
        navigationController.isModalInPresentation = false
        navigationController.modalPresentationStyle = .fullScreen
        viewControllerToPresentOn?.present(navigationController, animated: animated)
    }
    
    func goBack(viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissSecurityFlow(viewController: UIViewController) {
        delegate?.securityCoordinatorDismissSecurityFlow(coordinator: self)
    }
    
    //MARK: - verify email flow
    
    func securityViewController(viewController: UIViewController, verify email: String) {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.delegate = self
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func goToVerifyEmailFlow(viewController: UIViewController) {
        let emailViewController = SecurityEnterEmailViewController()
        emailViewController.delegate = self
        navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    //MARK: - change password flow
    
    func goToChangePasswordFlow(viewController: UIViewController, changeOrAddUrl: URL, isForAdd: Bool) {
        let changePasswordViewController = ChangePasswordViewController(viewModel: ChangePasswordViewModel(changeOrAddUrl: changeOrAddUrl, isForAdd: isForAdd))
        changePasswordViewController.delegate = self
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    func goToTwoFactorKeys(_ personalInfo: UserResponse) {
        let twoFactorViewController = TwoFactorKeysViewController(viewModel: TwoFactorKeysViewModel(personalInfo: personalInfo))
        twoFactorViewController.delegate = self
        navigationController?.pushViewController(twoFactorViewController, animated: true)
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
    
    func requestPasswordResetLink(viewController: UIViewController, personalInfo: UserResponse) {
        let passwordResetLinkViewController = PasswordResetLinkViewController(viewModel: PasswordResetLinkViewModel(personalInfo: personalInfo))
        passwordResetLinkViewController.delegate = self
        navigationController?.pushViewController(passwordResetLinkViewController, animated: true)
    }
    
    func goToCheckEmail(viewController: UIViewController, email: String?) {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.emailToCheck = email
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func goToDeleteKeyConfirmationScreen(viewController: UIViewController, identity: Identity) {
        let viewModel = DeleteKeyConfirmationViewModel(identity: identity)
        let confirmDeleteKeyViewController = DeleteKeyConfirmationViewController(viewModel: viewModel)
        confirmDeleteKeyViewController.delegate = self
        navigationController?.pushViewController(confirmDeleteKeyViewController, animated: true)
    }
    
    func hasPendingPersonalInfo() -> Bool {
        return pendingPersonalInfo != nil
    }
    
    func getAndRemovePendingPersonalInfo() -> UserResponse? {
        let result = pendingPersonalInfo
        pendingPersonalInfo = nil
        return result
    }
    
    func goToMainScreenWithPersonalInfo(_ personalInfo: UserResponse) {
        pendingPersonalInfo = personalInfo
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goBackAfterRemovingTwoFactorKey() {
        navigationController?.popViewController(animated: true)
        if let twoFactorKeysVc = navigationController?.topViewController as? TwoFactorKeysViewController {
            twoFactorKeysVc.refreshData()
        }
    }
}

