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
    func start() {
        let viewModel = ScanViewModel()
        let scanViewcontroller = ScanViewController(viewModel: viewModel)
        viewModel.delegate = scanViewcontroller
        scanViewcontroller.delegate = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        navigationController.isModalInPresentation = false
        navigationController.modalPresentationStyle = .fullScreen
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
        ScreenType.isQrEnrolment = false
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
    
    func verifyScanResultViewControllerDisplayOneTimeCode(code: String, challenge: AuthenticationChallenge) {
        let oneTimeCodeVc = OneTimeCodeViewController()
        oneTimeCodeVc.modalPresentationStyle = .fullScreen
        oneTimeCodeVc.oneTimeCode = code
        oneTimeCodeVc.delegate = self
        oneTimeCodeVc.authenticationChallenge = challenge
        navigationController.pushViewController(oneTimeCodeVc, animated: true)
    }
}

extension ScanCoordinator: OneTimeCodeViewControllerDelegate {
    func oneTimeCodeViewControllerDelegateGoBack() {
        navigationController.popViewController(animated: true)
    }
    func oneTimeCodeViewControllerDelegateCloseFlow() {
        delegate?.scanCoordinatorDismissScanScreen(coordinator: self)
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
