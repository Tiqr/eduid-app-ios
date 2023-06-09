import UIKit
import TiqrCoreObjC
import AVFoundation

protocol ScanViewModelDelegate: AnyObject {
    func scanViewModelAddPoints(_for object: AVMetadataMachineReadableCodeObject, viewModel: ScanViewModel)
    func scanViewModelShowScanAttempt(viewModel: ScanViewModel)
    func scanViewModelShowErrorAlert(error: Any, viewModel: ScanViewModel)
    func scanViewModelAuthenticateSuccess(viewModel: ScanViewModel)
}
