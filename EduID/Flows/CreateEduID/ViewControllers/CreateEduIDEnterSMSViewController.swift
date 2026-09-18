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
    
    /// When set, this is called instead of the default `CreateEduIDViewControllerDelegate` navigation,
    /// so this screen can be reused outside of the onboarding flow (e.g. re-verifying an SMS recovery number).
    var onSMSVerified: (() -> Void)?
    
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
        let eduIdError = EduIdError.from(error, kind: .smsCode)
        let alertController = UIAlertController(title: eduIdError.title,
                                                message: eduIdError.message,
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
            guard let self else { return }
            if let onSMSVerified = self.onSMSVerified {
                onSMSVerified()
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    func smsEntryWasCorrect() {
        if let onSMSVerified {
            onSMSVerified()
        } else {
            (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
        }
    }
}
