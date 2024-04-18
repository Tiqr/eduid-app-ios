//
//  ExpandableControl.swift
//  eduID
//
//  Created by Dániel Zolnai on 11/04/2024.
//

import Foundation
import UIKit

class ExpandableControl: UIControl {
    
    internal var isExpanded = false
    internal var stack: UIStackView!
    internal var chevronImage: UIView!
        
    init() {
        super.init(frame: .zero)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - expand or contract action
    @objc
    func expandOrContract() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else {
                return
            }
            for i in 1 ..< self.stack.arrangedSubviews.count {
                self.stack.arrangedSubviews[i].isHidden = !self.isExpanded
                self.stack.arrangedSubviews[i].alpha = self.isExpanded ? 1 : 0
            }
            let radian = 180 * CGFloat.pi / 180
            self.backgroundColor = self.isExpanded ? .supportBlueColor : .white
            self.layer.shadowRadius = self.isExpanded ? 4 : 0
            self.layer.shadowOpacity = self.isExpanded ? 0.2 : 0
            self.chevronImage.transform = self.chevronImage.transform.rotated(by: radian)
            animateViewsOnExpandOrContract(self.isExpanded)
        }
    }
    
    func animateViewsOnExpandOrContract(_ isExpanded: Bool) {
        // Override in your control if needed
    }
    
}
