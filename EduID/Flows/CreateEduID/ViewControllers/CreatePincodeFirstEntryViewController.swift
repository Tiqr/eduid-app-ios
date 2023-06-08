import UIKit

class CreatePincodeFirstEntryViewController: PincodeBaseViewController {
    
    let createPincodeViewModel: CreatePincodeAndBiometricAccessViewModel
    
    //MARK: - init
    init(viewModel: CreatePincodeAndBiometricAccessViewModel) {
        self.createPincodeViewModel = viewModel
        super.init(viewModel: PinViewModel(), isSecure: true)
        screenType = .pincodeScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .createPincodefirstEntryScreen
        
        posterLabel.text = "Select a PIN code"
        textLabel.text = "To use the eduID app you need a PIN code."
        verifyButton.buttonTitle = "Next"
        verifyButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func showNextScreen() {
        createPincodeViewModel.firstEnteredPin = viewModel.pinValue
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowConfirmPincodeScreen(viewController: self, viewModel: createPincodeViewModel)
    }
}
