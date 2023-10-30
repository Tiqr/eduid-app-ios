import UIKit
import TiqrCoreObjC

final class ScanCoordinator: NSObject, CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController!
    weak var delegate: ScanCoordinatorDelegate?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    //MARK: - start
    func start(for mode: ScanType) {
        let viewModel = ScanViewModel()
        let scanViewcontroller = ScanViewController(viewModel: viewModel, for: mode)
        viewModel.delegate = scanViewcontroller
        scanViewcontroller.delegate = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
}
    
//MARK: methods from the scan screen
extension ScanCoordinator: ScanViewControllerDelegate {
       
    func scanViewControllerDismissScanFlow(viewController: ScanViewController) {
        delegate?.scanCoordinatorDismissScanScreen(coordinator: self)
    }
    
    func scanViewControllerPromptUserWithVerifyScreen(viewController: ScanViewController, viewModel: ScanViewModel) {
        let verifyViewController = VerifyScanResultViewController(viewModel: viewModel)
        verifyViewController.delegate = self
        navigationController.pushViewController(verifyViewController, animated: true)
    }
    
    func scanViewControllerShowConfirmScreen(viewController: ScanViewController) {
        let confirmViewController = ConfirmViewController()
        confirmViewController.delegate = self
        navigationController.pushViewController(confirmViewController, animated: true)
    }
    
    func verifyScanResultForEnroll(viewController: ScanViewController, viewModel: ScanViewModel) {
        navigationController.dismiss(animated: true)
        delegate?.scanCoordinatorJumpToCreatePincodeScreen(coordinator: self, viewModel: viewModel)
    }
}

//MARK: - enroll a user using a qr code
extension ScanCoordinator: VerifyScanResultViewControllerDelegate {
    
    func verifyScanResultViewControllerEnroll(viewController: VerifyScanResultViewController, viewModel: ScanViewModel) {
        navigationController.dismiss(animated: true)
        delegate?.scanCoordinatorJumpToCreatePincodeScreen(coordinator: self, viewModel: viewModel)
    }
    
    func verifyScanResultViewControllerLogin(viewController: VerifyScanResultViewController, viewModel: ScanViewModel) {
        let pincodeFirstEntryViewController = CreatePincodeFirstEntryViewController(
            viewModel: CreatePincodeAndBiometricAccessViewModel(
                authenticationChallenge: viewModel.challenge as? AuthenticationChallenge
            )
        )
        navigationController.pushViewController(pincodeFirstEntryViewController, animated: true)
    }
    
    func verifyScanResultViewControllerCancelScanResult(viewController: VerifyScanResultViewController) {
        navigationController.popToRootViewController(animated: true)
        (navigationController.viewControllers.first as? ScanViewController)?.viewModel.session.startRunning()
    }
}

//MARK: - confirm login and dismiss flow
extension ScanCoordinator: ConfirmViewControllerDelegate {
    
    func confirmViewControllerDismiss(viewController: ConfirmViewController) {
        navigationController?.presentingViewController?.dismiss(animated: true)
    }
}

//MARK: transition setup
extension ScanCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: false)
    }
}
