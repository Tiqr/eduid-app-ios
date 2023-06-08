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
                    backgroundColor = R.color.grayDisabledBackground()
                case .ghost:
                    layer.borderColor = R.color.grayDisabled()!.cgColor
                case .naked:
                    break
                }
            case true:
                switch type {
                case .primary:
                    backgroundColor = R.color.primaryColor()
                case .ghost:
                    layer.borderColor = R.color.grayGhost()!.cgColor
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
        backgroundColor = R.color.primaryColor()
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : R.font.sourceSansProRegular(size: 16), .foregroundColor: UIColor.white])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        let attributedTitleDisabled = NSAttributedString(string: buttonTitle, attributes: [.font : R.font.sourceSansProRegular(size: 16), .foregroundColor: R.color.grayDisabled()])
        setAttributedTitle(attributedTitleDisabled, for: .disabled)
        
    }
    
    private func setupWithGhostStyle(isDelete: Bool = false) {
        backgroundColor = .white
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : R.font.sourceSansProRegular(size: 16), .foregroundColor: isDelete ? UIColor.red : R.color.grayGhost()])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        
        layer.borderWidth = 1
        layer.borderColor = isDelete ? UIColor.red.cgColor : R.color.grayGhost()!.cgColor
    }
    
    private func setupWithNakedStyle() {
        backgroundColor = .clear
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : R.font.sourceSansProRegular(size: 16), .foregroundColor: R.color.primaryColor()])
        setAttributedTitle(attributedTitleNormal, for: .normal)
    }

}
