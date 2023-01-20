//
//  AnimatedStackView.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 20/01/2023.
//

import UIKit

class AnimatedStackView: UIStackView {
    
    func hideAndTriggerAll() {
        arrangedSubviews.forEach { view in
            view.alpha = 0
            view.transform = CGAffineTransformMakeTranslation(2, 0)
        }
    }
    
    func animate() {
        arrangedSubviews.enumerated().forEach { (index, view) in
            UIView.animate(withDuration: 1, delay: Double(index) / 16, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3) {
                view.transform = .identity
            }
            UIView.animate(withDuration: 0.3) {
                view.alpha = 1
            }
        }
    }
}
