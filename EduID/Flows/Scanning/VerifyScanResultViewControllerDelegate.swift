import UIKit

protocol VerifyScanResultViewControllerDelegate: AnyObject {
    
    func verifyScanResultViewControllerLogin(viewController: VerifyScanResultViewController, viewModel: ScanViewModel)
    func verifyScanResultViewControllerEnroll(viewController: VerifyScanResultViewController, viewModel: ScanViewModel)
    func verifyScanResultViewControllerCancelScanResult(viewController: VerifyScanResultViewController)
}
