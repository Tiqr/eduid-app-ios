//
//  AuthenticateWithPinViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 18/02/2023.
//

import UIKit

class AuthenticateWithPinViewController: PincodeBaseViewController {
    
    weak var authenticateDelegate: AuthenticateWithPinViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        posterLabel.text = "Enter your PIN code"
        textLabel.text = "To use the eduID for authentication you need to enter your PIN code."
        verifyButton.buttonTitle = "Authenticate"
    }
    
    override func showNextScreen() {

    }
}
