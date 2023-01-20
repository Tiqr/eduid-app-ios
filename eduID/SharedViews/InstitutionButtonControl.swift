import UIKit
import TinyConstraints

class InstitutionButtonControl: UIControl {

    init(label1: String, label2: String) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryColor.cgColor
        
        height(70)
        
        //MARK: - stackview
        let firstLabel = UILabel()
        firstLabel.font = .sourceSansProBold(size: 16)
        firstLabel.textColor = .charcoal
        firstLabel.text = label1
        firstLabel.height(20)
        
        let secondLabel = UILabel()
        secondLabel.font = .sourceSansProRegular(size: 12)
        secondLabel.textColor = .charcoal
        secondLabel.text = label2
        secondLabel.height(20)
        
        let stack = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        self.backgroundColor = .white
        
        addSubview(stack)
        stack.edges(to: self, insets: TinyEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        firstLabel.width(to: stack)
        secondLabel.width(to: stack)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
