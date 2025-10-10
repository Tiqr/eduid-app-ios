import UIKit

protocol CreateEduIDViewControllerDelegate: AnyObject, NavigationDelegate {
    func goBack(viewController: UIViewController)
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController)
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController)
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel)
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel)
    func createEduIDViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController)
    func createEduIDViewControllerShowLinkingErrorScreen(linkedAccountEmail: String?)
    func goToAddPasswordScreen(hash: String)
}

extension CreateEduIDViewControllerDelegate {
    func goBack(viewController: UIViewController) { }
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController) { }
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController) { }
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) { }
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) { }
    func createEduIDViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController) { }
    func createEduIDViewControllerShowLinkingErrorScreen(linkedAccountEmail: String?) { }
    func goToAddPasswordScreen(hash: String) { }
}
