import UIKit

protocol PersonalInfoCoordinatorDelegate: AnyObject {
    
    func personalInfoCoordinatorDismissPersonalInfoFlow(coordinator: CoordinatorType)
    func goToOnboarding()
}
