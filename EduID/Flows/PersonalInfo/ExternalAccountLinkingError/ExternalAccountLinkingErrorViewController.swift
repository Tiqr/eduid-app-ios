//
//  ExternalAccountLinkingErrorViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 18..
//

import Foundation
import UIKit
import TinyConstraints

class ExternalAccountLinkingErrorViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .externalAccountLinkingError
    var delegate: PersonalInfoViewControllerDelegate?
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let mainTitle = UILabel.posterTextLabelBicolor(
            text: L.ExternalAccountLinkingError.Title.localization,
            size: 24,
            primary: L.ExternalAccountLinkingError.Title.localization
        )
        
        let subtitle = UILabel.subtitleLabel(text: L.ExternalAccountLinkingError.Subtitle.localization)
        
        let accessDeniedImageView = UIImageView()
        accessDeniedImageView.image = .accessDenied
        accessDeniedImageView.height(180)
        accessDeniedImageView.contentMode = .scaleAspectFit
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let tryOtherOptionsButton = EduIDButton(type: .primary, buttonTitle: L.ExternalAccountLinkingError.TryAnotherOption.localization)
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            accessDeniedImageView,
            subtitle,
            spacer,
            tryOtherOptionsButton
        ])
        
        mainTitle.widthToSuperview()
        subtitle.widthToSuperview()
        spacer.widthToSuperview()
        accessDeniedImageView.widthToSuperview()
        tryOtherOptionsButton.widthToSuperview()

        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        topStackView.setCustomSpacing(88, after: mainTitle)
        topStackView.setCustomSpacing(44, after: accessDeniedImageView)
        
        view.addSubview(topStackView)
        topStackView.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 16, right: 24), usingSafeArea: true)
        tryOtherOptionsButton.addTarget(self, action: #selector(otherOptionsClicked), for: .touchUpInside)
    }

    @objc
    func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc
    func otherOptionsClicked() {
        delegate?.goBackToVerifyIdentityScreen()
    }
}
