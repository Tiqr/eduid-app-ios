import UIKit
import TinyConstraints

class CreateEduIDEnterSMSViewController: PincodeBaseViewController {
    
    //MARK: - init
    override init(viewModel: PinViewModel, isSecure: Bool) {
        super.init(viewModel: viewModel, isSecure: isSecure)
        
        screenType = .smsChallengeScreen
        
        viewModel.smsEntryWasCorrect = { [weak self] result in
            self?.showNextScreen2()
        }
        viewModel.smsEntryFailed = { [weak self] alertTitle, alertMessage in
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .cancel) { [weak self] _ in
                var firstPinField:PinTextFieldView?
                self?.pinStack.subviews.forEach { pinView in
                    if let pinField = pinView as? PinTextFieldView {
                        if firstPinField == nil {
                            firstPinField = pinField
                        }
                        pinField.textfield.text = nil
                    }
                }
                firstPinField?.textfield.becomeFirstResponder()
            }
            alertController.addAction(alertAction)
            self?.present(alertController, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNextScreen() {
        viewModel.enterSMS(code: viewModel.pinValue.reduce("", { partialResult, char in
            partialResult + String(char)
        }))
    }
    
    func showNextScreen2() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}
