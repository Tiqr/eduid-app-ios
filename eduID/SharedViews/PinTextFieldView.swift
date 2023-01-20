//
//  PinTextFieldView.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 20/01/2023.
//

import UIKit
import TinyConstraints

class PinTextFieldView: UIView, UITextFieldDelegate {
    
    weak var delegate: PinTextFieldDelegate?
    
    //MARK: - Create the textfield
    let textfield = UITextField()

    //MARK: - initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        
        //MARK: setup size
        height(50)
        width(50)
        
        //MARK: - set border properties
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        
        //MARK: create parent view
        let parentView = UIView()
        parentView.layer.cornerRadius = 4
        parentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(parentView)
        parentView.edges(to: self, insets: TinyEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor.tertiary.cgColor
        
        //MARK: - create textfield
        textfield.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(textfield)
        textfield.width(20)
        textfield.height(20)
        textfield.tintColor = .clear
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
        delegate?.didEnterPinNumber(tag: tag)
        return true
    }
    
    //MARK: - focus method
    
    func focus() {
        textfield.becomeFirstResponder()
    }
    
    //MARK: resign keyboard responder
    override func resignFirstResponder() -> Bool {
        textfield.resignFirstResponder()
    }
    
}

protocol PinTextFieldDelegate: AnyObject {
    func didEnterPinNumber(tag: Int)
}
