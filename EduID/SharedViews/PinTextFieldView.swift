import UIKit
import TinyConstraints

class PinTextFieldView: UIView, UITextFieldDelegate {
    
    weak var delegate: PinTextFieldDelegate?
    var screenType: ScreenType
    
    // - Create the textfield
    let textfield = UITextField()

    //MARK: - initialize
    init(isSecure: Bool, screenType: ScreenType) {
        self.screenType = screenType
        
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        layer.cornerRadius = 5
        
        // - setup size
        height(50)
        width(50)
        
        // - set border properties
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        
        // - create parent view
        let parentView = UIView()
        parentView.layer.cornerRadius = 4
        parentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(parentView)
        parentView.edges(to: self, insets: TinyEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.tertiaryColor.cgColor
        
        // - create textfield
        textfield.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(textfield)
        textfield.width(20)
        textfield.height(20)
        textfield.tintColor = .clear
        textfield.isSecureTextEntry = isSecure
        textfield.keyboardType = .numberPad
        textfield.center(in: parentView)
        textfield.textAlignment = .center
        textfield.font = .sourceSansProRegular(size: 20)
        textfield.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - delegate methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.textfieldFocusColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = string
        delegate?.didEnterPinNumber(range: screenType == .pincodeScreen ? 3 : 5, tag: tag, value: string.first ?? "0")
        return true
    }
    
    //MARK: - focus method
    
    func focus() {
        textfield.becomeFirstResponder()
    }
    
    //MARK: - keyboard responder
    override func resignFirstResponder() -> Bool {
        textfield.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        textfield.becomeFirstResponder()
    }
    
    //MARK: - tapped
    @objc
    func tapped() {
        textfield.becomeFirstResponder()
    }
}

protocol PinTextFieldDelegate: AnyObject {
    func didEnterPinNumber(range: Int, tag: Int, value: Character)
}
