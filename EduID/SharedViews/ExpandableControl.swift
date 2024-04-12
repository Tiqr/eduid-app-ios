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
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else {
                return
            }
            for i in 1 ..< self.stack.arrangedSubviews.count {
                self.stack.arrangedSubviews[i].isHidden = self.isExpanded
                self.stack.arrangedSubviews[i].alpha = self.isExpanded ? 0 : 1
            }
            let radian = 180 * CGFloat.pi / 180
            self.backgroundColor = self.isExpanded ? .white : .supportBlueColor
            self.layer.shadowRadius = self.isExpanded ? 0 : 4
            self.layer.shadowOpacity = self.isExpanded ? 0 : 0.3
            self.chevronImage.transform = self.chevronImage.transform.rotated(by: radian)
        }
        isExpanded.toggle()
    }
    
}
