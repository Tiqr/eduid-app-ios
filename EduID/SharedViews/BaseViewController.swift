//
//  BaseViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 06/02/2023.
//

import UIKit

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}

class BaseViewController: UIViewController, ScreenWithScreenType {
    
    //  - screentype
    var screenType: ScreenType = .none

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: self.navigationItem, target: self, action: #selector(goBack))
    }
    
    @objc
    func goBack() {
        
    }
}
