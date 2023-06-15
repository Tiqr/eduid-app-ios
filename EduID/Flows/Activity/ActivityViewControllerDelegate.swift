import UIKit
import OpenAPIClient

protocol ActivityViewControllerDelegate: AnyObject {
    func activityViewControllerDismissActivityFlow(viewController: UIViewController)
    func goToDeleteService(service: EduID)
    func goBack(from: UIViewController, shouldUpdate: Bool)
    func shouldUpdate() -> Bool
    func didUpdate()
}
