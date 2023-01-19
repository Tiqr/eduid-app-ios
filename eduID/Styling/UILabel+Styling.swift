//
//  UILable+Styling.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//
import UIKit

extension UILabel {
    static func posterTextLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.proximaNovaSoftSemiBold(size: size)
        label.textAlignment = .center
        label.textColor = UIColor.secondaryColor
        
        var paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .center
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        return label
    }
}
