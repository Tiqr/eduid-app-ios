//
//  DeleteKeyConfirmationViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 11. 16..
//

import Foundation
import UIKit
import TinyConstraints

class DeleteKeyConfirmationViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityDeleteKeyConfirmation
    
    private let viewModel: DeleteKeyConfirmationViewModel
        
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    init(viewModel: DeleteKeyConfirmationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        
        let titleString = L.ConfirmDeleteKey.Title.localization
        let mainTitle = UILabel.posterTextLabelBicolor(text: titleString, size: 24, primary: titleString)
        
        let disclaimerContainer = UIView()
        let disclaimerLabel = UILabel()
        let warningImage = UIImageView()
        warningImage.image = .warning
        warningImage.size(CGSize(width: 22.5, height: 21))
        let disclaimerString = NSMutableAttributedString(
            string: L.ConfirmDeleteKey.Subtitle.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .charcoalColor, lineSpacing: 6)
        )
        disclaimerContainer.addSubview(disclaimerLabel)
        disclaimerContainer.addSubview(warningImage)
        warningImage.leftToSuperview(offset: 12)
        warningImage.topToSuperview(offset: 12)
        disclaimerLabel.attributedText = disclaimerString
        disclaimerLabel.leftToRight(of: warningImage, offset: 12)
        disclaimerLabel.rightToSuperview(offset: -12)
        disclaimerLabel.verticalToSuperview(insets: .vertical(12))
        disclaimerLabel.numberOfLines = 0
        disclaimerContainer.backgroundColor = UIColor.alertsBackgroundColor
        
        let descriptionLabel = UILabel.plainTextLabelPartlyBold(text: L.ConfirmDeleteKey.Description.localization)
        
        let bottomSpacer = UIView()

        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            disclaimerContainer,
            descriptionLabel,
            bottomSpacer
        ])
        
        disclaimerContainer.widthToSuperview()
        bottomSpacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        topStackView.addArrangedSubview(bottomSpacer)
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.ConfirmDeleteKey.Button.Cancel.localization)
        let confirmButton = EduIDButton(type: .filledRed, buttonTitle: L.ConfirmDeleteKey.Button.Confirm.localization)
           
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            cancelButton,
            confirmButton
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 20
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        topStackView.edgesToSuperview(insets: .horizontal(24) + .top(24), usingSafeArea: true)
        
        bottomStackView.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(16))

        // Add click targets
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(removeAndGoBack), for: .touchUpInside)
    }
    
    @objc func removeAndGoBack() {
        viewModel.removeIdentity()
        delegate?.goBackAfterRemovingTwoFactorKey()
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
