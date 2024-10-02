//
//  SelectBankOptionControl.swift
//  eduID
//
//  Created by Dániel Zolnai on 01/10/2024.
//
import UIKit
import TinyConstraints
import OpenAPIClient

class SelectBankOptionControl: UIControl {
    
    private var delegate: () -> ()
    
    init(
        issuer: VerifyIssuer,
        clickDelegate: @escaping () -> ()
    ) {
        self.delegate = clickDelegate
        super.init(frame: .zero)
        
        // icon on the left
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage.bigPlus // TODO determine from issuer
        iconView.size(CGSize(width: 48, height: 48))
        
        // name on the right
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.attributedText = NSAttributedString(
            string: issuer.name ?? "",
            attributes: [
                .font: UIFont.sourceSansProSemiBold(size: 16),
                .foregroundColor: UIColor.backgroundColor
            ]
        )
        
        // - the master stack
        let stack = UIStackView(arrangedSubviews: [iconView, nameLabel])
        stack.axis = .horizontal
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.edges(to: self)
        stack.height(72)
        
        self.addTarget(self, action: #selector(onSelfTouchUpInside), for: .touchUpInside)
        
        layer.borderColor = UIColor.backgroundColor.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSelfTouchUpInside() {
        self.delegate()
    }

}
