import UIKit

extension UIView {
    func setShadow(path: UIBezierPath? = nil, opacity: Float, color: UIColor, radius: CGFloat, offset: CGSize) {
        if let path = path {
            layer.shadowPath = path.cgPath
        }
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
    }
}
