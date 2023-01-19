//
//  EduIDNavigationItem.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit

class EduIDNavigationItem: UINavigationItem {

    init() {
        super.init(title: "")
        
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        titleView = logo
        
        backBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: nil, action: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
