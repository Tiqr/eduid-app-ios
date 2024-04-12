import UIKit

extension NSMutableAttributedString {
    func setAttributeTo(part: String, attributes: [NSAttributedString.Key: Any]?) {
        setAttributes(attributes, range: string.range(of: part)?.nsRange(in: string) ?? NSRange())
                            
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

struct AttributedStringHelper {
    
    static func attributes(font: UIFont, color: UIColor, lineSpacing: CGFloat, underline: Bool = false) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        var mutableDict: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        if underline {
            mutableDict[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return mutableDict
    }
}
