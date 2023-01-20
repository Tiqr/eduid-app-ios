//
//  PhoneChallengeViewController.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 20/01/2023.
//

import UIKit
import TinyConstraints

class EnterPhoneNumberViewController: EduIDBaseViewController, UITextFieldDelegate {

    let extraBorderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Your eduID has been created", size: 24)
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Let’s add a recovery phonenumber
If you can't access eduID with the app or via email, you can use this to sign in to your eduID Account.

We will text you a code to verify your number.
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : UIFont.sourceSansProSemiBold(size: 16)], range: NSRange(location: 0, length: 32))
        textView.attributedText = attributedText
    
        //MARK: - challenge textfield
        let textField = UITextField()
        textField.font = .sourceSansProRegular(size: 16)
        textField.placeholder = "e.g. 0612345678"
        textField.delegate = self
        textField.height(20)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad

        //MARK: - textfield border
        extraBorderView.layer.borderWidth = 2
        extraBorderView.layer.borderColor = UIColor.clear.cgColor
        extraBorderView.layer.cornerRadius = 8
        let textFieldParent = UIView()
        extraBorderView.addSubview(textFieldParent)
        extraBorderView.height(52)
        textFieldParent.height(48)
        textFieldParent.center(in: extraBorderView)
        textFieldParent.leading(to: extraBorderView, offset: 2)
        textFieldParent.trailing(to: extraBorderView, offset: -2)
        textFieldParent.layer.cornerRadius = 6
        textFieldParent.layer.borderWidth = 1
        textFieldParent.layer.borderColor = UIColor.tertiary.cgColor
        textFieldParent.addSubview(textField)
        textField.center(in: textFieldParent)
        textField.width(to: textFieldParent, offset: -24)
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - verify button
        let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this phone number")
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textView, extraBorderView, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        textView.height(120)
        extraBorderView.width(to: stack)
        posterLabel.height(34)
        verifyButton.width(to: stack)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        extraBorderView.layer.borderColor = UIColor.textfieldFocusColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        extraBorderView.layer.borderColor = UIColor.clear.cgColor
    }
}
