import UIKit
import OpenAPIClient

class PersonalInfoCoordinator: CoordinatorType, PersonalInfoViewControllerDelegate {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var delegate: PersonalInfoCoordinatorDelegate?
    weak var navigationController: UINavigationController?
    
    private var didUpdateData = false
    
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
    
    func goToEmailEditor(viewController: UIViewController) {
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
    
    func goBackToInfoScreen(updateData: Bool) {
        navigationController?.popToRootViewController(animated: true)
        self.didUpdateData = updateData
    }
    
    func goToNameOverview(viewController: UIViewController, personalInfo: UserResponse) {
        let nameOverviewViewController = NameOverviewViewController(viewModel: NameOverviewViewModel(personalInfo: personalInfo))
        nameOverviewViewController.delegate = self
        navigationController!.pushViewController(nameOverviewViewController, animated: true)
    }
    
    func goToNameUpdated(viewController: UIViewController, linkedAccount: LinkedAccount) {
        self.didUpdateData = true
        let nameUpdatedViewController = NameUpdatedViewController(viewModel: NameUpdatedViewModel(linkedAccount: linkedAccount))
        nameUpdatedViewController.delegate = self
        navigationController!.pushViewController(nameUpdatedViewController, animated: true)
    }
    
    func goToNameEditor(viewController: UIViewController) {
        let nameEditorViewController = NameEditorViewController(viewModel: NameEditorViewModel())
        nameEditorViewController.delegate = self
        navigationController!.pushViewController(nameEditorViewController, animated: true)
    }
    
    func goToMyAccount(viewController: UIViewController, personalInfo: UserResponse) {
        let myAccountViewController = MyAccountViewController(viewModel: MyAccountViewModel(personalInfo: personalInfo))
        myAccountViewController.delegate = self
        navigationController!.pushViewController(myAccountViewController, animated: true)
    }
    
    func goToDeleteAccount(viewController: UIViewController, personalInfo: UserResponse) {
        let deleteAccountViewController = DeleteAccountViewController(viewModel: DeleteAccountViewModel(personalInfo:  personalInfo))
        deleteAccountViewController.delegate = self
        navigationController!.pushViewController(deleteAccountViewController, animated: true)
    }
    
    func goToConfirmDeleteAccount(viewController: UIViewController, personalInfo: UserResponse) {
        // TODO
    }
    
    func shouldUpdateData() -> Bool {
        return self.didUpdateData
    }
    
    @objc
    func goBack(viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}
