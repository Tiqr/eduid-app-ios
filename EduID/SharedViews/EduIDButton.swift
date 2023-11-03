import UIKit
import TinyConstraints

final class EduIDButton: UIButton {
    
    enum ButtonType {
        case primary
        case ghost
        case naked
        case borderedRed
        case filledRed
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
            case .borderedRed:
                setupWithBorderedRedStyle()
            case .filledRed:
                setupWithFilledRedStyle()
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
                case .ghost, .borderedRed:
                    layer.borderColor = UIColor.disabledGray.cgColor
                case .filledRed:
                    backgroundColor = UIColor.alertsRedColor.withAlphaComponent(0.5)
                case .naked:
                    break
                }
            case true:
                switch type {
                case .primary:
                    backgroundColor = UIColor.primaryColor
                case .ghost, .borderedRed:
                    layer.borderColor = UIColor.grayGhost.cgColor
                case .filledRed:
                    backgroundColor = UIColor.alertsRedColor
                case .naked:
                    break
                }
            }
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            switch type {
            case .borderedRed:
                backgroundColor = isHighlighted ? .alertsRedColor.withAlphaComponent(0.2) : .clear
            case .filledRed:
                backgroundColor = isHighlighted ? .alertsRedColor.withAlphaComponent(0.8) : .alertsRedColor
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

    
    init(type: ButtonType, buttonTitle: String, frame: CGRect? = nil) {
        self.type = type
        self.buttonTitle = buttonTitle
        if let frameRect = frame {
            super.init(frame: frameRect)
            height(frameRect.height)
        } else {
            super.init(frame: .zero)
            height(48)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 6
        
        switch type {
        case .primary:
            setupWithPrimaryStyle()
        case .ghost:
            setupWithGhostStyle()
        case .naked:
            setupWithNakedStyle()
        case .borderedRed:
            setupWithBorderedRedStyle()
        case .filledRed:
            setupWithFilledRedStyle()
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
    
    private func setupWithBorderedRedStyle() {
        backgroundColor = .clear
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.alertsRedColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.alertsRedColor.cgColor
    }
    
    private func setupWithFilledRedStyle() {
        backgroundColor = .alertsRedColor
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.white])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        layer.borderWidth = 0
    }
    
    private func setupWithNakedStyle() {
        backgroundColor = .clear
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.primaryColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
    }

}
