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
    
    func editEmail(viewController: UIViewController) {
        let emailEditorViewController = EmailEditorViewController(viewModel: EmailEditorViewModel())
        emailEditorViewController.delegate = self
        navigationController!.pushViewController(emailEditorViewController, animated: true)
    }
    
    
    func showConfirmEmailScreen(viewController: UIViewController, emailToVerify: String?) {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.emailToCheck = emailToVerify
        checkEmailViewController.delegate = self
        navigationController!.pushViewController(checkEmailViewController, animated: true)
    }
    
    func goBackToInfoScreen() {
        navigationController?.popToRootViewController(animated: true)
    }

    
    
    func editName(viewController: UIViewController) {
        // TODO implement
    }
    
    @objc
    func goBack(viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}
