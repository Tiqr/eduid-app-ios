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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.secondaryColor
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .center
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        return label
    }
    
    static func posterTextLabelBicolor(text: String, size: CGFloat, primary: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.secondaryColor
        label.numberOfLines = 0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.proximaNovaSoftSemiBold(size: size), .foregroundColor: UIColor.secondaryColor, NSAttributedString.Key.paragraphStyle : paragraph])
        attributedString.setAttributeTo(part: primary, attributes: [.font: UIFont.proximaNovaSoftSemiBold(size: size), .foregroundColor: UIColor.primaryColor, NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        
        return label
    }
}
