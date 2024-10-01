import UIKit
import TiqrCoreObjC

extension UILabel {
    static func posterTextLabel(text: String, size: CGFloat = 24, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = alignment
        label.textColor = UIColor.secondaryColor
        label.sizeToFit()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = alignment
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraph,
                                                                             NSAttributedString.Key.font: UIFont.proximaNovaSoftSemiBold(size: size)])
        label.attributedText = attributedString
        return label
    }
    
    static func posterTextLabelBicolor(frame: CGRect? = nil, text: String, size: CGFloat = 24, primary: String, alignment: NSTextAlignment = .left) -> UILabel {
        var label = UILabel()
        if let labelFrame = frame {
            label = UILabel(frame: labelFrame)
        }
        label.textAlignment = alignment
        label.textColor = UIColor.secondaryColor
        label.numberOfLines = 0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        paragraph.alignment = alignment
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.proximaNovaSoftSemiBold(size: size), .foregroundColor: UIColor.secondaryColor, NSAttributedString.Key.paragraphStyle : paragraph])
        attributedString.setAttributeTo(part: primary, attributes: [.font: UIFont.proximaNovaSoftSemiBold(size: size), .foregroundColor: UIColor.primaryColor, NSAttributedString.Key.paragraphStyle : paragraph])
        label.attributedText = attributedString
        
        return label
    }
    
    static func plainTextLabelPartlyBold(text: String, partBold: String = "", alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.sourceSansProRegular(size: 14), .foregroundColor: UIColor.charcoalColor, .paragraphStyle: paragraphStyle])
        attributedString.setAttributeTo(part: partBold, attributes: [.font: UIFont.sourceSansProSemiBold(size: 14), .foregroundColor: UIColor.charcoalColor, .paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        label.sizeToFit()
        return label
    }
    
    static func subtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.sourceSansProRegular(size: 16),
                .foregroundColor: UIColor.charcoalColor,
                .paragraphStyle: paragraphStyle
            ])
        label.attributedText = attributedString
        label.sizeToFit()
        return label
    }
}
