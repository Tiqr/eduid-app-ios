import UIKit

protocol CoordinatorType: AnyObject {
    
    var viewControllerToPresentOn: UIViewController? { get set }
    
    init(viewControllerToPresentOn: UIViewController?)
}
