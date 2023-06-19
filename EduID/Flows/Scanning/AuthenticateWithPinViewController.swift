import UIKit

class AuthenticateWithPinViewController: PincodeBaseViewController {
    
    weak var authenticateDelegate: AuthenticateWithPinViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        posterLabel.text = L.PinAndBioMetrics.PinScreenEnterTitle.localization
        textLabel.text = L.PinAndBioMetrics.AuthenticateForUseTitle.localization
        verifyButton.buttonTitle = L.PinAndBioMetrics.Authenticate.localization
    }
    
    override func showNextScreen() {

    }
}
