import UIKit
import OpenAPIClient
import TiqrCoreObjC

protocol SecurityViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func goBack(viewController: UIViewController)
    func goToMainScreenWithPersonalInfo(_ personalInfo: UserResponse)
    func dismissSecurityFlow(viewController: UIViewController)
    func goToTwoFactorKeys(_ personalInfo: UserResponse)
    func goBackAfterRemovingTwoFactorKey()
    
    func hasPendingPersonalInfo() -> Bool
    func getAndRemovePendingPersonalInfo() -> UserResponse?
    
    func goToVerifyEmailFlow(viewController: UIViewController)
    func goToChangePasswordFlow(viewController: UIViewController, changeOrAddUrl: URL, isForAdd: Bool)
    func goToCheckEmail(viewController: UIViewController, email: String?)
    func goToDeleteKeyConfirmationScreen(viewController: UIViewController, identity: Identity)
    func requestPasswordResetLink(viewController: UIViewController, personalInfo: UserResponse)
    func securityViewController(viewController: UIViewController, verify email: String)
    func securityViewController(viewController: UIViewController, reset password: String)
}
