//
//  EduIDValidatedTextStackView.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit
import TinyConstraints

class EduIDValidatedTextStackView: UIStackView, UITextFieldDelegate {
    
    let validLabel = UILabel()
    weak var delegate: ValidatedTextFieldDelegate?
    
    init(regex: String? = nil, title: String, placeholder: String) {
        super.init(frame: .zero)
        
        axis = .vertical
        spacing = 6
        
        //MARK: - title
        let label = UILabel()
        label.font = .sourceSansProSemiBold(size: 16)
        label.textColor = .charcoal
        label.text = title
        addArrangedSubview(label)
        
        //MARK: - textfield
        let textField = UITextField()
        textField.font = .sourceSansProRegular(size: 16)
        textField.placeholder = placeholder
        textField.delegate = self
        textField.height(20)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let textFieldParent = UIView()
        addArrangedSubview(textFieldParent)
        textFieldParent.width(to: self)
        textFieldParent.height(48)
        textFieldParent.layer.cornerRadius = 6
        textFieldParent.layer.borderWidth = 1
        textFieldParent.layer.borderColor = UIColor.tertiary.cgColor
        textFieldParent.addSubview(textField)
        textField.center(in: textFieldParent)
        textField.width(to: self, offset: -24)
        addArrangedSubview(textFieldParent)
        
        //MARK: - validationMessage
        validLabel.font = .sourceSansProSemiBold(size: 12)
        validLabel.textColor = .red
        validLabel.text = "The input doesn't follow regex"
        validLabel.alpha = 0
        addArrangedSubview(validLabel)
        
        height(104)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 < 3 || textField.text?.count ?? 0 > 20 {
            validLabel.alpha = 1
            delegate?.updateValidation(with: false, from: tag)
        } else {
            validLabel.alpha = 0
            delegate?.updateValidation(with: true, from: tag)
        }
        return true
    }
}

protocol ValidatedTextFieldDelegate: AnyObject {
    
    func updateValidation(with value: Bool, from tag: Int)
}
