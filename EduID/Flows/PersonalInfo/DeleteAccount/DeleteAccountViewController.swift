//
//  DeleteAccountViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import UIKit
import TinyConstraints

class DeleteAccountViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .deleteAccountScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: DeleteAccountViewModel
    
    init(viewModel: DeleteAccountViewModel) {
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
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.DeleteAccount.Title.localization, size: 24, primary: L.DeleteAccount.Title.localization)
                

        let disclaimerContainer = UIView()
        let disclaimerLabel = UILabel()
        let warningImage = UIImageView()
        warningImage.image = .warning
        warningImage.size(CGSize(width: 22.5, height: 21))
        let disclaimerString = NSMutableAttributedString(
            string: L.DeleteAccount.Disclaimer.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        disclaimerContainer.addSubview(disclaimerLabel)
        disclaimerContainer.addSubview(warningImage)
        warningImage.leftToSuperview(offset: 12)
        warningImage.topToSuperview(offset: 18)
        disclaimerLabel.attributedText = disclaimerString
        disclaimerLabel.leftToRight(of: warningImage, offset: 12)
        disclaimerLabel.rightToSuperview(offset: -12)
        disclaimerLabel.verticalToSuperview(insets: .vertical(12))
        disclaimerLabel.numberOfLines = 0
        disclaimerContainer.backgroundColor = UIColor.yellowColor
        
        let longDescriptionLabel = UILabel()
        let longDescription = NSMutableAttributedString(
            string: L.DeleteAccount.LongDescription.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        longDescriptionLabel.numberOfLines = 0
        longDescriptionLabel.attributedText = longDescription
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let deleteAccountButton = EduIDButton(type: .borderedRed, buttonTitle: L.DeleteAccount.DeleteAccountButton.localization)
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            disclaimerContainer,
            longDescriptionLabel,
            spacer,
            deleteAccountButton
        ])
        
        mainTitle.widthToSuperview()
        disclaimerContainer.widthToSuperview()
        longDescriptionLabel.widthToSuperview()
        spacer.widthToSuperview()
        deleteAccountButton.widthToSuperview()

        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 12
        
        view.addSubview(topStackView)
        topStackView.edges(to: view, insets: TinyEdgeInsets(top: 72, left: 24, bottom: 24, right: 24))
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountClicked), for: .touchUpInside)
    }
    
    
    @objc func deleteAccountClicked() {
        delegate?.goToConfirmDeleteAccount(viewController: self, personalInfo: viewModel.personalInfo)
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
