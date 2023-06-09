import UIKit
import TinyConstraints

class TextViewBackgroundColor: UIView {

    init(attributedText: NSAttributedString, backgroundColor: UIColor, insets: UIEdgeInsets) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = .clear
        textLabel.attributedText = attributedText
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)
        textLabel.edges(to: self, insets: TinyEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
