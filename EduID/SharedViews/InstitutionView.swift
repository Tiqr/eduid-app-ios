import UIKit
import TinyConstraints

class InstitutionView: UIView {
    
    var action: () -> Void

    init(title: String, firstText: String, secondText: String, isValidated: Bool, action: @escaping () -> Void ) {
        self.action = action
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        height(105)
        
        let titleLabel = UILabel()
        titleLabel.font = R.font.sourceSansProSemiBold(size: 16)
        titleLabel.textColor = .charcoalColor
        titleLabel.text = title
        
        let control = InstitutionButtonControl(label1: firstText, label2: secondText)
        control.addTarget(self, action: #selector(didTapControl), for: .touchUpInside)
        control.setShadow(opacity: 0.3, color: .black, radius: 4, offset: CGSize(width: 3, height: 3))
        
        // - stackview
        let stack = UIStackView(arrangedSubviews: [titleLabel, control])
        stack.axis = .vertical
        stack.spacing = 12
        
        let shieldImage = UIImageView(image: .shield)
        shieldImage.size(CGSize(width: 36, height: 36))
        let parentStack = UIStackView(arrangedSubviews: [stack, shieldImage])
        shieldImage.isHidden = !isValidated
        
        addSubview(parentStack)
        stack.edges(to: self)
        
        control.width(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func didTapControl() {
        action()
    }
    

}
