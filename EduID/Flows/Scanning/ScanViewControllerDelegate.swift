import UIKit

protocol ScanViewControllerDelegate: AnyObject {
    
    func scanViewControllerDismissScanFlow(viewController: ScanViewController)
    func scanViewControllerPromptUserWithVerifyScreen(viewController: ScanViewController, viewModel: ScanViewModel)
    func scanViewControllerShowConfirmScreen(viewController: ScanViewController)
    func verifyScanResultForEnroll(viewController: ScanViewController, viewModel: ScanViewModel)
}
