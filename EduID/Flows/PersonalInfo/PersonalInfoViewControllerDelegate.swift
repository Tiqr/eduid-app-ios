import UIKit
import OpenAPIClient

protocol PersonalInfoViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func personalInfoViewControllerDismissPersonalInfoFlow(viewController: UIViewController)
    func goBack(viewController: UIViewController)
    func goBackToInfoScreen(updateData: Bool)
    func editEmail(viewController: UIViewController)
    func goToNameOverview(viewController: UIViewController, personalInfo: UserResponse)
    func goToNameUpdated(viewController: UIViewController, linkedAccount: LinkedAccount)
    func showConfirmEmailScreen(viewController: UIViewController, emailToVerify: String?)
    func shouldUpdateData() -> Bool
}
