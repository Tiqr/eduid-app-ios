import UIKit
import OpenAPIClient

protocol PersonalInfoViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func personalInfoViewControllerDismissPersonalInfoFlow(viewController: UIViewController)
    func goBack(viewController: UIViewController)
    func goBackToInfoScreen(updateData: Bool)
    func goToEmailEditor(viewController: UIViewController)
    func goToNameOverview(viewController: UIViewController, personalInfo: UserResponse)
    func goToNameEditor(viewController: UIViewController, personalInfo: UserResponse)
    func goToNameUpdated(viewController: UIViewController, linkedAccount: LinkedAccount)
    func goToMyAccount(viewController: UIViewController, personalInfo: UserResponse)
    func goToDeleteAccount(viewController: UIViewController, personalInfo: UserResponse)
    func goToConfirmDeleteAccount(viewController: UIViewController, personalInfo: UserResponse)
    func goToAccountLinkingErrorScreen(linkedAccountEmail: String?)
    func showConfirmEmailScreen(viewController: UIViewController, emailToVerify: String?)
    func shouldUpdateData() -> Bool
    func deleteStateAndGoToHome()
}
