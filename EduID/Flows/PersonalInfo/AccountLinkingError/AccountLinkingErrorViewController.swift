//
//  AccountLinkingErrorViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 08/02/2024.
//

import Foundation
import UIKit
import TinyConstraints

protocol AccountLinkingErrorDelegate {
    func accountLinkingErrorGoBack(viewController: UIViewController)
    func accountLinkingErrorRetryLinking(viewController: UIViewController)
}

class AccountLinkingErrorViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .accountLinkingError
    var delegate: AccountLinkingErrorDelegate!
    
    private var viewModel: AccountLinkingErrorViewModel
    
    init(viewModel: AccountLinkingErrorViewModel) {
        self.viewModel = viewModel
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
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.EppnAlreadyLinked.Title.localization, size: 24, primary: L.EppnAlreadyLinked.Title.localization)
        mainTitle.attributedText = NSAttributedString(
            string: L.EppnAlreadyLinked.Title.localization,
            attributes: AttributedStringHelper.attributes(font: .proximaNovaSoftSemiBold(size: 24), color: .alertsRedColor, lineSpacing: 16)
        )
        let descriptionLabel = UILabel()
        let description = NSMutableAttributedString(
            string: L.EppnAlreadyLinked.Info(args: viewModel.linkedAccountEmail ?? "?").localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = description
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let retryButton = EduIDButton(type: .primary, buttonTitle: L.EppnAlreadyLinked.RetryButton.localization)
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            descriptionLabel,
            spacer,
            retryButton
        ])
        
        mainTitle.widthToSuperview()
        descriptionLabel.widthToSuperview()
        spacer.widthToSuperview()
        retryButton.widthToSuperview()

        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 24
        
        view.addSubview(topStackView)
        topStackView.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 16, right: 24), usingSafeArea: true)
        retryButton.addTarget(self, action: #selector(retryClicked), for: .touchUpInside)
    }
    
    @objc
    func retryClicked() {
        delegate.accountLinkingErrorRetryLinking(viewController: self)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate.accountLinkingErrorGoBack(viewController: self)
    }
}
