import UIKit

protocol BiometricApprovalViewControllerDelegate: AnyObject {
    
    func biometricApprovalViewControllerContinueWithSucces(viewController: BiometricAccessApprovalViewController)
    func biometricApprovalViewControllerSkipBiometricAccess(viewController: BiometricAccessApprovalViewController)
}

extension BiometricApprovalViewControllerDelegate {
    func biometricApprovalViewControllerContinueWithSucces(viewController: BiometricAccessApprovalViewController){}
    func biometricApprovalViewControllerSkipBiometricAccess(viewController: BiometricAccessApprovalViewController){}
}
