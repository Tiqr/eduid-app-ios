import UIKit
import TinyConstraints

protocol AlertErrorHandlerDelegate: AnyObject {
    func smsDeactivationWasSuccess()
    func presentAlert(with error: Error)
    func smsEntryWasCorrect()
}
extension AlertErrorHandlerDelegate {
    func smsDeactivationWasSuccess(){}
    func smsEntryWasCorrect(){}
}

class CreateEduIDEnterSMSViewController: PincodeBaseViewController {
    
    var isDeactivationMode: Bool?
    
    //MARK: - init
    override init(viewModel: PinViewModel, isSecure: Bool) {
        super.init(viewModel: viewModel, isSecure: isSecure)
        screenType = .smsChallengeScreen
        viewModel.smsActivationHandlerDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showNextScreen(_ sender: UIButton? = nil) {
        sender?.isUserInteractionEnabled = false
        let smsCode = viewModel.pinValue.reduce("", { partialResult, char in partialResult + String(char)})
        if isDeactivationMode != nil {
            viewModel.performSMSDeactivation(with: smsCode)
        } else {
            viewModel.enterSMS(code: smsCode)
        }
    }
}

extension CreateEduIDEnterSMSViewController: AlertErrorHandlerDelegate {
    
    func presentAlert(with error: Error) {
        let alertController = UIAlertController(title: error.eduIdResponseError().title,
                                                message: error.eduIdResponseError().message,
                                                preferredStyle: .alert)
        
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
            self?.verifyButton.isUserInteractionEnabled = true
        }
        
        alertController.addAction(alertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
    
    func smsDeactivationWasSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    func smsEntryWasCorrect() {
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
}
