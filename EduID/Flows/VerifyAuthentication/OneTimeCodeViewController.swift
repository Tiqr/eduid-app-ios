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
        
        let title = L.OneTimePassword.Title.localization
        let subtitle = L.OneTimePassword.Description.localization
        
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
        
        let idText = L.OneTimePassword.YourId.localization + " " + authenticationChallenge.identity.identifier
        let yourIdLabel = UILabel.plainTextLabelPartlyBold(text: idText, partBold: authenticationChallenge.identity.identifier)
        let otcText = L.OneTimePassword.OneTimePassword.localization
        let otcLabel = UILabel.plainTextLabelPartlyBold(text: otcText)

        let unverifiedPinLabel = UILabel.plainTextLabelPartlyBold(text: L.OneTimePassword.PinNotVerified.Title.localization)
        let retryLabel = UILabel.plainTextLabelPartlyBold(text: L.OneTimePassword.PinNotVerified.Description.localization)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let closeButton = EduIDButton(type: .primary, buttonTitle: L.OneTimePassword.CloseButton.localization)
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
