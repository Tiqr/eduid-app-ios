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
        let checkEmailViewController = EmailLoginCodeViewController(viewModel: .init(emailCodeFlow: .changeEmail))
        checkEmailViewController.delegate = self
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func goToEmailCodeScreen(viewController: UIViewController, changePassword: Bool) {
        let checkEmailViewController = EmailLoginCodeViewController(viewModel: .init(emailCodeFlow: changePassword ? .changePassword : .addPassword))
        checkEmailViewController.delegate = self
        checkEmailViewController.createEduIDViewControllerDelegate = self
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
        let checkEmailViewController = CheckEmailViewController(emailToCheck: email)
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func goToDeleteKeyConfirmationScreen(viewController: UIViewController, identity: Identity) {
        let viewModel = DeleteKeyConfirmationViewModel(identity: identity)
        let confirmDeleteKeyViewController = DeleteKeyConfirmationViewController(viewModel: viewModel)
        confirmDeleteKeyViewController.delegate = self
        navigationController?.pushViewController(confirmDeleteKeyViewController, animated: true)
    }
    
    func goToDeletePasskeyConfirmationScreen(viewController: UIViewController, personalInfo: UserResponse, passkey: PublicKeyCredentials) {
        let viewModel = DeletePasskeyConfirmationViewModel(personalInfo: personalInfo, passkey: passkey)
        let confirmDeletePasskeyViewController = DeletePasskeyConfirmationViewController(viewModel: viewModel)
        confirmDeletePasskeyViewController.delegate = self
        navigationController?.pushViewController(confirmDeletePasskeyViewController, animated: true)
    }
    
    func goBackAfterRemovingPasskey(_ personalInfo: UserResponse) {
        navigationController?.popViewController(animated: true)
        if let securityOverviewVc = navigationController?.topViewController as? SecurityOverviewViewController {
            securityOverviewVc.setupUI(personalInfo: personalInfo)
        }
    }
    
    func goToChangeSMSRecoveryExplanationScreen(viewController: UIViewController, personalInfo: UserResponse) {
        let viewModel = ChangeSMSRecoveryExplanationViewModel(personalInfo: personalInfo)
        let changeSMSRecoveryExplanationViewController = ChangeSMSRecoveryExplanationViewController(viewModel: viewModel)
        changeSMSRecoveryExplanationViewController.delegate = self
        navigationController?.pushViewController(changeSMSRecoveryExplanationViewController, animated: true)
    }
    
    func goToChangeSMSRecoveryPhoneNumberScreen(viewController: UIViewController, personalInfo: UserResponse) {
        let phoneNumberViewController = CreateEduIDEnterPhoneNumberViewController(viewModel: CreateEduIDEnterPhoneNumberViewModel(isReVerification: true))
        phoneNumberViewController.delegate = self
        phoneNumberViewController.onPhoneNumberVerified = { [weak self] in
            self?.goToChangeSMSRecoverySMSCodeScreen()
        }
        navigationController?.pushViewController(phoneNumberViewController, animated: true)
    }
    
    private func goToChangeSMSRecoverySMSCodeScreen() {
        let smsViewController = CreateEduIDEnterSMSViewController(viewModel: PinViewModel(isReVerification: true), isSecure: false)
        smsViewController.delegate = self
        smsViewController.onSMSVerified = { [weak self] in
            self?.showChangeSMSRecoverySuccessDialog()
        }
        navigationController?.pushViewController(smsViewController, animated: true)
    }
    
    private func showChangeSMSRecoverySuccessDialog() {
        let alert = UIAlertController(
            title: L.ChangeSMSRecovery.Success.Title.localization,
            message: L.ChangeSMSRecovery.Success.Description.localization,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L.ChangeSMSRecovery.Success.Button.localization, style: .default) { [weak self] _ in
            self?.goBackAfterChangingSMSRecovery()
        })
        navigationController?.topViewController?.present(alert, animated: true)
    }
    
    func goBackAfterChangingSMSRecovery() {
        // Pop back to the security overview screen, past the explanation, phone number and code entry screens.
        if let securityOverviewVc = navigationController?.viewControllers.first(where: { $0 is SecurityOverviewViewController }) {
            navigationController?.popToViewController(securityOverviewVc, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
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

extension SecurityCoordinator: CreateEduIDViewControllerDelegate {
    func goToAddPasswordScreen(hash: String, changePassword: Bool) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let passwordCreationViewController = PasswordCreationViewController(viewModel: .init(hash: hash), changePassword: changePassword)
            self.navigationController?.pushViewController(passwordCreationViewController, animated: true)
        }
    }
}
