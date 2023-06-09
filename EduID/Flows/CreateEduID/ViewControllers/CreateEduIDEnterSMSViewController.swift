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
