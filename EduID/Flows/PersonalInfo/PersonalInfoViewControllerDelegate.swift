import UIKit

protocol PersonalInfoViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func personalInfoViewControllerDismissPersonalInfoFlow(viewController: UIViewController)
    func goBack(viewController: UIViewController)
    func goBackToInfoScreen()
    func editEmail(viewController: UIViewController)
    func editName(viewController: UIViewController)
    func showConfirmEmailScreen(viewController: UIViewController, emailToVerify: String?)
}
