import UIKit
import TinyConstraints

final class EduIDButton: UIButton {
    
    enum ButtonType {
        case primary
        case ghost
        case naked
        case red
    }

    let type: ButtonType
    var buttonTitle: String {
        didSet {
            switch type {
            case .primary:
                setupWithPrimaryStyle()
            case .ghost:
                setupWithGhostStyle()
            case .naked:
                setupWithNakedStyle()
            case .red:
                setupWithRedStyle()
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
                case .ghost, .red:
                    layer.borderColor = UIColor.disabledGray.cgColor
                
                case .naked:
                    break
                }
            case true:
                switch type {
                case .primary:
                    backgroundColor = UIColor.primaryColor
                case .ghost, .red:
                    layer.borderColor = UIColor.grayGhost.cgColor
                case .naked:
                    break
                }
            }
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            switch type {
            case .red:
                backgroundColor = isHighlighted ? .alertsRedColor.withAlphaComponent(0.2) : .white
            case .primary:
                backgroundColor = isHighlighted ? .primaryColor.withAlphaComponent(0.8) : .primaryColor
            case .ghost:
                backgroundColor = isHighlighted ? .grayGhost.withAlphaComponent(0.2) : .white
            default:
                // Don't change background color
                return
            }
        }
    }

    
    init(type: ButtonType, buttonTitle: String) {
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
            setupWithGhostStyle()
        case .naked:
            setupWithNakedStyle()
        case .red:
            setupWithRedStyle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWithPrimaryStyle() {
        backgroundColor = UIColor.primaryColor
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.white])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        let attributedTitleDisabled = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.disabledGray])
        setAttributedTitle(attributedTitleDisabled, for: .disabled)
        
    }
    
    private func setupWithGhostStyle() {
        backgroundColor = .white
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.grayGhost])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.grayGhost.cgColor
    }
    
    private func setupWithRedStyle() {
        backgroundColor = .white
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.alertsRedColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.alertsRedColor.cgColor
    }
    
    private func setupWithNakedStyle() {
        backgroundColor = .clear
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.primaryColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
    }

}
