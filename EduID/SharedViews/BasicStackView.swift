import UIKit

class BasicStackView: UIStackView {
    
    init(arrangedSubviews: [UIView]) {
        super.init(frame: .zero)
        
        arrangedSubviews.forEach { view in
            addArrangedSubview(view)
        }
        axis = .vertical
        spacing = 16
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fill
        alignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
