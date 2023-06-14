//
//  MyAccountViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import UIKit

class MyAccountViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .yourAccountScreen
     
     // - delegate
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    private let viewModel: MyAccountViewModel
    
    init(viewModel: MyAccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
