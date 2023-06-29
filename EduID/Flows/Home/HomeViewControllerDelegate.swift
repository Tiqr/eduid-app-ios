import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController, loadData: Bool)
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController)
    func homeViewControllerShowActivityScreen(viewController: HomeViewController)
    func homeViewControllerShowScanScreen(viewController: HomeViewController)
    func homeViewControllerShowAuthenticationScreen(with payload: String)
}
