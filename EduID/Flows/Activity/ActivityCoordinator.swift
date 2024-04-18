import UIKit
import OpenAPIClient

final class ActivityCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    private var needsUpdate = true
    
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    weak var navigationController: UINavigationController?
    weak var delegate: ActivityCoordinatorDelegate?
    
    
    //MARK: - start
    func start(refreshDelegate: RefreshChildScreenDelegate, animated: Bool) {
        let activityViewController = ActivityViewController(viewModel: ActivityViewModel())
        activityViewController.delegate = self
        activityViewController.refreshDelegate = refreshDelegate
        let navigationController = UINavigationController(rootViewController: activityViewController)
        self.navigationController = navigationController
        navigationController.isModalInPresentation = false
        navigationController.modalPresentationStyle = .fullScreen
        viewControllerToPresentOn?.present(navigationController, animated: animated)
    }
}

//MARK: - activity view controller delegate
extension ActivityCoordinator: ActivityViewControllerDelegate {
    
    func goBack(from: UIViewController, shouldUpdate: Bool = false) {
        self.needsUpdate = shouldUpdate
        if from.navigationController == nil {
            from.dismiss(animated: true)
            // In this case, the viewWillAppear will not trigger of the top VC, so we call it manually
            navigationController?.topViewController?.viewWillAppear(true)
            navigationController?.topViewController?.viewDidAppear(true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    func activityViewControllerDismissActivityFlow(viewController: UIViewController) {
        delegate?.activityCoordinatorDismissActivityFlow(coordinator: self)
    }
    
    func goToDeleteService(service: EduID) {
        let viewController = DeleteServiceViewController(viewModel: DeleteServiceViewModel(service: service))
        viewController.delegate = self
        viewController.modalPresentationStyle = .pageSheet
        navigationController?.present(viewController, animated: true)
    }
    
    func goToDeleteTokens(serviceName: String, tokensToDelete: [Token]) {
        let viewController = DeleteTokensViewController(viewModel: DeleteTokensViewModel(serviceName: serviceName, tokensToDelete: tokensToDelete))
        viewController.delegate = self
        viewController.modalPresentationStyle = .pageSheet
        navigationController?.present(viewController, animated: true)
    }
    
    func shouldUpdate() -> Bool {
        return self.needsUpdate
    }
    
    func didUpdate() {
        self.needsUpdate = false
    }
}
