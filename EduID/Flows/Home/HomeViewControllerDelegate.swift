import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController, loadData: Bool, animated: Bool)
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController, animated: Bool)
    func homeViewControllerShowActivityScreen(viewController: HomeViewController, animated: Bool)
    func homeViewControllerShowScanScreen(viewController: HomeViewController)
    func homeViewControllerShowAuthenticationScreen(with payload: String)
}
