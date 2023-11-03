import UIKit
import TinyConstraints

protocol VerifyPinCodeDelegate: NSObject {
    func get(pinCode: String)
}

final class VerifyPinCodeViewController: PincodeBaseViewController {
    
    weak var pinDelegate: VerifyPinCodeDelegate?
    
    //MARK: - init
    init() {
        super.init(viewModel: PinViewModel(), isSecure: true)
        verifyButton.isHidden = true
        screenType = .pincodeScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupAppearance() {
        posterLabel.text = L.PinAndBioMetrics.PinScreenEnterTitle.localization
        textLabel.text = L.PinAndBioMetrics.VerifyPinScreenText.localization
        
        let approveButton = EduIDButton(type: .primary, buttonTitle: L.PinAndBioMetrics.OKButton.localization)
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.Modal.Cancel.localization)
        approveButton.addTarget(self, action: #selector(approveAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        let buttonsStack = AnimatedHStackView(arrangedSubviews: [cancelButton, approveButton])
        buttonsStack.spacing = 24
        buttonsStack.distribution = .fillEqually
        mainStack.insertArrangedSubview(buttonsStack, at: 5)
        buttonsStack.width(to: mainStack)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc func approveAction() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.pinDelegate?.get(pinCode: self.enteredPinValue())
        }
    }
    
    private func enteredPinValue() -> String {
        return viewModel.pinValue.dropLast(2).map { String($0) }.joined()
    }
 
}
