import UIKit

protocol ScanCoordinatorDelegate: AnyObject {
    
    func scanCoordinatorDismissScanScreen(coordinator: ScanCoordinator)
    func scanCoordinatorJumpToCreatePincodeScreen(coordinator: ScanCoordinator, viewModel: ScanViewModel)
}
