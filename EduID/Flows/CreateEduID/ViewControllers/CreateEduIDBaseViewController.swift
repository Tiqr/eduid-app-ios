import UIKit

class CreateEduIDBaseViewController: BaseViewController {
    
    weak var delegate: NavigationDelegate?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - obj methods for navigation
    @objc
    override func goBack() {
        delegate?.goBack(viewController: self)
    }
    
    @objc
    func showNextScreen() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
    
    @objc
    func showScanScreen() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowScanScreen(viewController: self)
    }

}
