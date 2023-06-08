import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController)
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController)
    func homeViewControllerShowActivityScreen(viewController: HomeViewController)
    func homeViewControllerShowScanScreen(viewController: HomeViewController)
}
