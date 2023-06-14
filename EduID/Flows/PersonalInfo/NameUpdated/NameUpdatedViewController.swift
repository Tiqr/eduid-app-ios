//
//  NameUpdatedViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 13..
//

import Foundation
import UIKit
import TinyConstraints

class NameUpdatedViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .personalInfoNameUpdatedScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: NameUpdatedViewModel

    init(viewModel: NameUpdatedViewModel) {
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
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        let fullTitleString = "\(L.NameUpdated.Title.YourSchool.localization)\n\(L.NameUpdated.Title.ContactedSuccessfully.localization)"
        let mainTitle = UILabel.posterTextLabelBicolor(text: fullTitleString, size: 24, primary: L.NameUpdated.Title.YourSchool.localization)
        let subTitle = UILabel.plainTextLabelPartlyBold(text: L.NameUpdated.Description.localization)
        let bottomSpacer = UIView()


        let verifiedName = "\(viewModel.linkedAccount.givenName ?? "") \(viewModel.linkedAccount.familyName ?? "")"
        let nameTitle = NSAttributedString(string: L.NameUpdated.FullName.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
        let nameProvidedByText = NSMutableAttributedString(string: "\(verifiedName)\n\(L.Profile.ProvidedBy.localization) \(viewModel.linkedAccount.schacHomeOrganization ?? "?")", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6))
        nameProvidedByText.setAttributeTo(part: L.Profile.ProvidedBy.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        nameProvidedByText.setAttributeTo(part: viewModel.linkedAccount.schacHomeOrganization ?? "?", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 12), color: .charcoalColor, lineSpacing: 6))
        let nameControl = ActionableControlWithBodyAndTitle(
            attributedTitle: nameTitle,
            attributedBodyText: nameProvidedByText,
            iconInBody: .shield.withRenderingMode(.alwaysOriginal),
            isFilled: true
        )
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            subTitle,
            nameControl
        ])
        
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        topStackView.addArrangedSubview(bottomSpacer)
        scrollView.addSubview(topStackView)
        topStackView.edges(to: scrollView, insets: TinyEdgeInsets(top: 36, left: 24, bottom: 24, right: -24))
        topStackView.width(to: scrollView, offset: -48)
        nameControl.width(to: topStackView)
        
        let bottomButton = EduIDButton(type: .primary, buttonTitle: L.NameUpdated.Continue.localization)
        bottomButton.addTarget(self, action: #selector(onContinueClicked), for: .touchUpInside)
        view.addSubview(bottomButton)
        bottomButton.edgesToSuperview(excluding: .top, insets: .horizontal(24) + .bottom(24))
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBackToInfoScreen(updateData: false)
    }
    
    @objc func onContinueClicked() {
        delegate?.goBack(viewController: self)
    }
}
