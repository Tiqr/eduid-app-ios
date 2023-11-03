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
        createPincodeViewModel.showErrorDialogClosure = { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: L.Generic.RequestError.Title.localization,
                message: error.localizedFromApi,
                preferredStyle: .alert)
            alert.addAction(.init(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { _ in
                alert.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
        
        createPincodeViewModel.redoCreatePincodeClosure = { [weak self] in
            guard let self = self else { return }
            (self.delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerRedoCreatePin(viewController: self)
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
