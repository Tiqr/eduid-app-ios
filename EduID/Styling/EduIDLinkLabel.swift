//
//  EduIDLinkLabel.swift
//  eduID
//
//  Created by Yasser Farahi on 30/05/2025.
//

import UIKit

class EduIDLinkLabel: UILabel {
    
    private var linkRange: NSRange?
    private var onLinkTap: (() -> Void)?

    func set(normalText: String,
             linkText: String,
             normalFont: UIFont = UIFont.sourceSansProRegular(size: 16),
             normalColor: UIColor = .darkGray,
             linkFont: UIFont = UIFont.sourceSansProRegular(size: 16),
             linkColor: UIColor = UIColor.backgroundColor,
             underline: Bool = true,
             onLinkTap: @escaping () -> Void) {
        
        let full = normalText + " " + linkText
        let attributedString = NSMutableAttributedString(string: full)

        let normalRange = (full as NSString).range(of: normalText)
        attributedString.addAttributes([
            .font: normalFont,
            .foregroundColor: normalColor
        ], range: normalRange)

        let linkRange = (full as NSString).range(of: linkText)
        var linkAttributes: [NSAttributedString.Key: Any] = [
            .font: linkFont,
            .foregroundColor: linkColor
        ]
        if underline {
            linkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        attributedString.addAttributes(linkAttributes, range: linkRange)

        self.attributedText = attributedString
        self.numberOfLines = 0
        self.isUserInteractionEnabled = true
        self.linkRange = linkRange
        self.onLinkTap = onLinkTap
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            let text = attributedText,
            let linkRange = linkRange
        else { return }

        let layout = NSLayoutManager()
        let container = NSTextContainer(size: bounds.size)
        let storage = NSTextStorage(attributedString: text)
        layout.addTextContainer(container)
        storage.addLayoutManager(layout)

        container.lineFragmentPadding = 0
        container.maximumNumberOfLines = numberOfLines
        container.lineBreakMode = lineBreakMode

        let point = touch.location(in: self)
        let index = layout.characterIndex(for: point, in: container, fractionOfDistanceBetweenInsertionPoints: nil)
        if NSLocationInRange(index, linkRange) {
            onLinkTap?()
        }
    }
}
