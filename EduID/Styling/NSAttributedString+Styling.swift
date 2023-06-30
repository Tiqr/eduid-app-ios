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
    
    static func attributes(font: UIFont, color: UIColor, lineSpacing: CGFloat) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
    }
}
