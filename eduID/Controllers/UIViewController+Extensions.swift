//
//  UIViewController+Extensions.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit

extension UIViewController {
    
    func horizontalEdgesToView(aView: UIView, offset: CGFloat) {
        aView.leading(to: view, offset: offset)
        aView.trailing(to: view, offset: -offset)
    }
}
