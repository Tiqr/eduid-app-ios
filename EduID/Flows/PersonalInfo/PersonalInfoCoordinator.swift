import UIKit

class PersonalInfoCoordinator: CoordinatorType, PersonalInfoViewControllerDelegate {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var delegate: PersonalInfoCoordinatorDelegate?
    weak var navigationController: UINavigationController?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    func start() {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        let editPersonalInfoViewcontroller = PersonalInfoViewController(viewModel: PersonalInfoViewModel())
        editPersonalInfoViewcontroller.delegate = self
        navigationController.isModalInPresentation = true
        navigationController.pushViewController(editPersonalInfoViewcontroller, animated: false)
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
    
    func personalInfoViewControllerDismissPersonalInfoFlow(viewController: UIViewController) {
        delegate?.personalInfoCoordinatorDismissPersonalInfoFlow(coordinator: self)
    }
    
    @objc
    func enterItem() {
        //TODO: implement screens
    }
    
    @objc
    func goBack(viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}
