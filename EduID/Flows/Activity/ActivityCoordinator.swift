import UIKit

final class ActivityCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    weak var navigationController: UINavigationController?
    weak var delegate: ActivityCoordinatorDelegate?
    
    //MARK: - start
    func start() {
        let activityViewController = ActivityViewController(viewModel: ActivityViewModel())
        activityViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: activityViewController)
        self.navigationController = navigationController
        navigationController.isModalInPresentation = true
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
}

//MARK: - activity view controller delegate
extension ActivityCoordinator: ActivityViewControllerDelegate {
    
    func activityViewControllerDismissActivityFlow(viewController: UIViewController) {
        delegate?.activityCoordinatorDismissActivityFlow(coordinator: self)
    }
}
