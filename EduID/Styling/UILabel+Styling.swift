//
//  UILable+Styling.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//
import UIKit
import TiqrCoreObjC

extension UILabel {
    static func posterTextLabel(text: String, size: CGFloat = 24, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.font.proximaSoftSemibold(size: size)
        label.numberOfLines = 0
        label.textAlignment = alignment
        label.textColor = R.color.secondaryColor()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = alignment
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        return label
    }
    
    static func posterTextLabelBicolor(text: String, size: CGFloat = 24, primary: String, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = alignment
        label.textColor = R.color.secondaryColor()
        label.numberOfLines = 0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = alignment
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: R.font.proximaSoftSemibold(size: size)!, .foregroundColor: R.color.secondaryColor()!, NSAttributedString.Key.paragraphStyle : paragraph])
        attributedString.setAttributeTo(part: primary, attributes: [.font: R.font.proximaSoftSemibold(size: size)!, .foregroundColor: R.color.primaryColor()!, NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        
        return label
    }
    
    static func plainTextLabelPartlyBold(text: String, partBold: String, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: R.font.sourceSansProRegular(size: 16)!, .foregroundColor: R.color.charcoalColor()!, .paragraphStyle: paragraphStyle])
        attributedString.setAttributeTo(part: partBold, attributes: [.font: R.font.sourceSansProSemiBold(size: 16)!, .foregroundColor: R.color.charcoalColor()!, .paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        return label
    }
    
    static func requestLoginLabel(entityName: String, challengeType: TIQRChallengeType) -> UILabel {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 16
        
        var labelString = ""
        switch challengeType {
        case .enrollment:
            labelString = "Request enrollment for user:\n"
        case .authentication:
            labelString = "Request login for:\n"
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString(string: "\(labelString)\(entityName)", attributes: [.font: R.font.sourceSansProSemiBold(size: 24)!, .foregroundColor: R.color.primaryColor()!, .paragraphStyle: paragraphStyle])
        attributedString.setAttributeTo(part: entityName, attributes: [.foregroundColor: R.color.charcoalColor()!, .font: R.font.sourceSansProSemiBold(size: 36)!, .paragraphStyle: paragraphStyle])
        let label = UILabel()
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
}
