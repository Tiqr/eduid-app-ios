import UIKit

class CreatePincodeSecondEntryViewController: PincodeBaseViewController {

    let createPincodeViewModel: CreatePincodeAndBiometricAccessViewModel
    
    //MARK: - init
    init(viewModel: CreatePincodeAndBiometricAccessViewModel) {
        self.createPincodeViewModel = viewModel
        super.init(viewModel: PinViewModel(), isSecure: true)
        screenType = .pincodeScreen
        createPincodeViewModel.showUseBiometricScreenClosure = { [weak self] in
            guard let self = self else { return }
            
            (self.delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowBiometricUsageScreen(viewController: self, viewModel: self.createPincodeViewModel)
        }
        
        createPincodeViewModel.redoCreatePincodeClosure = { [weak self] in
            guard let self = self else { return }
            (self.delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerRedoCreatePin(viewController: self)
        }
        
        createPincodeViewModel.errorExistingUserNotDisconnectAppWantsEnrol = { [weak self] in
            let smsVerification = CreateEduIDEnterSMSViewController(viewModel: PinViewModel(), isSecure: false)
            smsVerification.modalPresentationStyle = .fullScreen
            smsVerification.isDeactivationMode = true
            self?.present(smsVerification, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .createPincodeSecondEntryScreen
        
        verifyButton.buttonTitle = L.Modal.Confirm.localization
        textLabel.text = L.PinAndBioMetrics.SecondPinScreenText.localization
        posterLabel.text = L.PinAndBioMetrics.SecondPinScreenSelectTitle.localization
        verifyButton.isEnabled = false
    }
    
    override func showNextScreen(_ sender: UIButton? = nil) {
        createPincodeViewModel.secondEnteredPin = viewModel.pinValue
        createPincodeViewModel.verifyPinSimilarity()
    }
}
