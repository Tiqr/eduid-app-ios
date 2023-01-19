//
//  EduIDBaseViewController.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit

class EduIDBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        navigationItem.titleView = logo
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: self, action: #selector(backTapped))
        
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
    
    @objc
    private func backTapped() {
        if navigationController?.viewControllers.count == 2 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        navigationController?.popViewController(animated: true)
    }

}
