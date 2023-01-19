//
//  EduIDButton.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit

final class EduIDButton: UIButton {
    
    enum ButtonType {
        case primary
        case ghost
        case naked
    }

    var type: ButtonType
    var buttonTitle: String
    
    override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case false:
                switch type {
                case .primary:
                    backgroundColor = UIColor.disabledGrayBackground
                case .ghost:
                    break
                case .naked:
                    break
                }
            case true:
                switch type {
                case .primary:
                    backgroundColor = UIColor.primaryColor
                case .ghost:
                    break
                case .naked:
                    break
                }
            }
        }
    }
    
    init(type: ButtonType, buttonTitle: String) {
        self.type = type
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 6
        
        switch type {
        case .primary:
            setupWithPrimaryStyle()
        case .ghost:
            setupWithGhostStyle()
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
    
    private func setupWithGhostStyle() {
        backgroundColor = .white
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.grayGhost])
        setAttributedTitle(attributedTitleNormal, for: .normal)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.grayGhost.cgColor
    }
    
    private func setupWithNakedStyle() {
        backgroundColor = .clear
        
        let attributedTitleNormal = NSAttributedString(string: buttonTitle, attributes: [.font : UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.primaryColor])
        setAttributedTitle(attributedTitleNormal, for: .normal)
    }

}
