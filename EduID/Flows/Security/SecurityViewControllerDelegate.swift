import UIKit

protocol SecurityViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func goBack(viewController: UIViewController)
    func securityViewControllerEnterVerifyEmailFlow(viewController: UIViewController)
    func securityViewControllerDismissSecurityFlow(viewController: UIViewController)
    func securityViewController(viewController: UIViewController, verify email: String)
    func securityViewControllerEnterChangePasswordFlow(viewController: UIViewController)
    func securityViewController(viewController: UIViewController, reset password: String)
}
