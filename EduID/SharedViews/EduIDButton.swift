import UIKit
import TinyConstraints

final class EduIDButton: UIButton {
    
    enum ButtonType {
        case primary
        case ghost
        case naked
    }

    var type: ButtonType
    var buttonTitle: String {
        didSet {
            switch type {
            case .primary:
                setupWithPrimaryStyle()
            case .ghost:
                setupWithGhostStyle()
            case .naked:
                setupWithNakedStyle()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case false:
                switch type {
                case .primary:
                    backgroundColor = UIColor.disabledGrayBackground
                case .ghost:
                    layer.borderColor = UIColor.disabledGray.cgColor
                case .naked:
                    break
                }
            case true:
                switch type {
                case .primary:
                    backgroundColor = UIColor.primaryColor
                case .ghost:
                    layer.borderColor = UIColor.grayGhost.cgColor
                case .naked:
                    break
                }
            }
        }
    }
    
    init(type: ButtonType, buttonTitle: String, isDelete: Bool = false) {
        self.type = type
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        height(48)
        
        layer.cornerRadius = 6
        
        switch type {
        case .primary:
            setupWithPrimaryStyle()
        case .ghost:
            setupWithGhostStyle(isDelete: isDelete)
        case .naked:
            setupWithNakedStyle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWithPrimaryStyle() {
        backgroundColor = UIColor.primaryColor
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.white])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        let attributedTitleDisabled = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.disabledGray])
        setAttributedTitle(attributedTitleDisabled, for: .disabled)
        
    }
    
    private func setupWithGhostStyle(isDelete: Bool = false) {
        backgroundColor = .white
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: isDelete ? UIColor.red : UIColor.grayGhost])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        
        layer.borderWidth = 1
        layer.borderColor = isDelete ? UIColor.red.cgColor : UIColor.grayGhost.cgColor
    }
    
    private func setupWithNakedStyle() {
        backgroundColor = .clear
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.primaryColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
    }

}
