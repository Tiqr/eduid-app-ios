import UIKit
import OpenAPIClient

protocol ActivityViewControllerDelegate: AnyObject {
    func activityViewControllerDismissActivityFlow(viewController: UIViewController)
    func goToDeleteService(service: EduID)
    func goToDeleteTokens(serviceName: String, tokensToDelete: [Token])
    func goBack(from: UIViewController, shouldUpdate: Bool)
    func shouldUpdate() -> Bool
    func didUpdate()
}
