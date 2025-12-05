//
//  VerifyIdentityControl.swift
//  eduID
//
//  Created by Dániel Zolnai on 30/09/2024.
//
import UIKit
import TinyConstraints

class VerifyIdentityButton: UIControl {
    
    private var clickHandler: (VerifyIdentityButton) -> ()
    private var loadingIndicator: UIActivityIndicatorView
    
    var isLoading: Bool {
        didSet {
            loadingIndicator.isHidden = !isLoading
            self.isUserInteractionEnabled = !isLoading
            if isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    init(title: String,
         icon: UIImage? = nil,
         highlighted: Bool,
         clickHandler: @escaping (VerifyIdentityButton) -> ()
    ) {
        self.clickHandler = clickHandler
        self.isLoading = false
        self.loadingIndicator = UIActivityIndicatorView(style: .medium)
        super.init(frame: .zero)
        let button = EduIDButton(type: highlighted ? .primary : .ghost, buttonTitle: title)
        let buttonContainer = UIView()
        buttonContainer.addSubview(button)
        button.edgesToSuperview()
        
        if icon != nil {
            let buttonIconView = UIImageView()
            buttonContainer.addSubview(buttonIconView)
            buttonIconView.image = icon
            buttonIconView.contentMode = .scaleAspectFit
            buttonIconView.size(CGSize(width: 30, height: 30))
            buttonIconView.leftToSuperview(offset: 20)
            buttonIconView.centerYToSuperview()
        }
        
        buttonContainer.addSubview(loadingIndicator)
        loadingIndicator.centerYToSuperview()
        loadingIndicator.rightToSuperview(offset: -12)
        

        button.widthToSuperview()
        button.addTarget(self, action: #selector(onButtonTouchUpInside), for: .touchUpInside)
        addSubview(buttonContainer)
        buttonContainer.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onButtonTouchUpInside() {
        self.clickHandler(self)
    }
}
