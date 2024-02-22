//
//  OneTimeCodeViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 11. 02..
//

import Foundation
import UIKit
import TiqrCore
import TinyConstraints
import TiqrCoreObjC

protocol OneTimeCodeViewControllerDelegate {
    func oneTimeCodeViewControllerDelegateGoBack()
    func oneTimeCodeViewControllerDelegateCloseFlow()
}


class OneTimeCodeViewController : BaseViewController {
    
    var oneTimeCode: String!
    var authenticationChallenge: AuthenticationChallenge!
    var delegate: OneTimeCodeViewControllerDelegate!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .oneTimeCodeScreen
        
        let title = Localization.localize("authentication_fallback_title", comment: "You appear to be offline")
        let subtitle = Localization.localize("authentication_fallback_description", comment: "Don\'t worry! Click the QR tag on the\nwebsite. You will be asked to enter the\nfollowing one-time credentials:")
        
        // - poster label
        let posterLabel = UILabel.posterTextLabelBicolor(text: title, primary: title)
        // - text
        let textLabel = UILabel.plainTextLabelPartlyBold(text: subtitle)
        
        
        let pinStack = AnimatedHStackView()
        // - pin fields
        pinStack.axis = .horizontal
        pinStack.distribution = .equalCentering
        pinStack.height(50)
        oneTimeCode.forEach { character in
            let pinField = PinTextFieldView(isSecure: false, screenType: screenType)
            pinField.textfield.text = String(character)
            pinField.textfield.isEnabled = false
            pinStack.addArrangedSubview(pinField)
        }
        
        let idText = Localization.localize("fallback_identifier_label", comment: "Your ID is:") + " " + authenticationChallenge.identity.identifier
        let yourIdLabel = UILabel.plainTextLabelPartlyBold(text: idText, partBold: authenticationChallenge.identity.identifier)
        let otcText = Localization.localize("otp_label", comment: "One time password:")
        let otcLabel = UILabel.plainTextLabelPartlyBold(text: otcText)

        let unverifiedPinLabel = UILabel.plainTextLabelPartlyBold(text: Localization.localize("note_pin_not_verified_title", comment: "Note: your PIN has not been verified yet"))
        let retryLabel = UILabel.plainTextLabelPartlyBold(text: Localization.localize("note_pin_not_verified", comment: "If you can\'t login with the credentials above, scan\nagain and enter the correct PIN code"))
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let closeButton = EduIDButton(type: .primary, buttonTitle: L.OneTimeCode.CloseButton.localization)
        closeButton.addTarget(self, action: #selector(closeFlow), for: .touchUpInside)

        let mainStackView = UIStackView(arrangedSubviews: [posterLabel, textLabel, yourIdLabel, otcLabel, pinStack, unverifiedPinLabel, retryLabel, spacer, closeButton])
        mainStackView.alignment = .leading
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 16
        mainStackView.setCustomSpacing(24, after: posterLabel)
        mainStackView.setCustomSpacing(24, after: textLabel)
        mainStackView.setCustomSpacing(32, after: pinStack)

        
        posterLabel.widthToSuperview()
        textLabel.widthToSuperview()
        pinStack.widthToSuperview()
        closeButton.widthToSuperview()
        view.addSubview(mainStackView)
        mainStackView.edgesToSuperview(insets: .horizontal(24) + .top(24) + .bottom(20), usingSafeArea: true)
    }
    
    @objc
    func closeFlow() {
        delegate.oneTimeCodeViewControllerDelegateCloseFlow()
    }
    
    override func goBack() {
        delegate.oneTimeCodeViewControllerDelegateGoBack()
    }
}
