//
//  NameOverviewViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 12..
//

import Foundation
import UIKit
import TinyConstraints

class NameOverviewViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .personalInfoNameOverviewScreen
    
    weak var delegate: PersonalInfoViewControllerDelegate?

    private var viewModel: NameOverviewViewModel
    
    private var addInstitutionButton: ActionableControlWithBodyAndTitle? = nil

    init(viewModel: NameOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.serviceRemovedClosure = { [weak self] _ in
            self?.setupUI()
        }
        viewModel.linkAddedClosure = { [weak self] linkedAccount in
            // TODO go to next screen
            let alert = UIAlertController(title: "Link added", message: "Added link: \(linkedAccount.subjectId)", preferredStyle: .alert)
            self?.present(alert, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc
    func willEnterForeground() {
        viewModel.checkIfLinkingCompleted()
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
        
        let fullTitleString = "\(L.NameOverview.Title.AllDetailsOf.localization)\n\(L.NameOverview.Title.FullName.localization)"
        let mainTitle = UILabel.posterTextLabelBicolor(text: fullTitleString, size: 24, primary: L.NameOverview.Title.FullName.localization)
        let bottomSpacer = UIView()


        let selfAssertedName = "\(viewModel.personalInfo.givenName ?? "") \(viewModel.personalInfo.familyName ?? "")"
        let nameTitle = NSAttributedString(string: L.NameOverview.SelfAsserted.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
        let nameProvidedByText = NSMutableAttributedString(string: "\(selfAssertedName)\n\(L.Profile.ProvidedBy.localization) \(L.Profile.Me.localization)", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6))
        nameProvidedByText.setAttributeTo(part: L.Profile.ProvidedBy.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        nameProvidedByText.setAttributeTo(part: L.Profile.Me.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 12), color: .charcoalColor, lineSpacing: 6))
        let nameControl = ActionableControlWithBodyAndTitle(attributedTitle: nameTitle, attributedBodyText: nameProvidedByText, iconInBody: .pencil.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            nameControl
        ])
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        let separatorTitleString: String
        if viewModel.personalInfo.linkedAccounts?.isEmpty == false {
            separatorTitleString = L.NameOverview.Verified.localization
        } else {
            separatorTitleString = L.NameOverview.AnotherSource.localization
        }
        let separatorTitleAttributedText = NSAttributedString(string: separatorTitleString, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6))
        let separatorLabel = UILabel()
        separatorLabel.attributedText = separatorTitleAttributedText
        let separatorIcon = UIImageView()
        separatorIcon.image = .verifiedBadge
        let separatorContainer = UIView()
        separatorContainer.addSubview(separatorIcon)
        separatorContainer.addSubview(separatorLabel)
        separatorIcon.leftToSuperview()
        separatorLabel.leftToRight(of: separatorIcon, offset: 8)
        separatorIcon.centerYToSuperview()
        separatorLabel.centerYToSuperview()
        separatorContainer.height(20)
        topStackView.addArrangedSubview(separatorContainer)
        topStackView.setCustomSpacing(8, after: separatorContainer)
        
        viewModel.personalInfo.linkedAccounts?.forEach { linkedAccount in
            let createdAt: Date?
            if let apiCreated = linkedAccount.createdAt {
                createdAt = Date(timeIntervalSince1970: Double(apiCreated) / 1000)
            } else {
                createdAt = nil
            }
            let expiresAt: Date?
            if let apiExpiresAt = linkedAccount.expiresAt {
                expiresAt = Date(timeIntervalSince1970: Double(apiExpiresAt) / 1000)
            } else {
                expiresAt = nil
            }
            
            let actionableControl = InstitutionControlCollapsible(
                title: "\(linkedAccount.givenName ?? "") \(linkedAccount.familyName ?? "")",
                institution: linkedAccount.schacHomeOrganization ?? "",
                verifiedAt: createdAt,
                affiliation: linkedAccount.eduPersonAffiliations?.first ?? "",
                expires: expiresAt
            ) { [weak self] in
                
                // - alert to confirm service removal
                let alert = UIAlertController(
                    title: L.Profile.RemoveServicePrompt.Title.localization,
                    message: L.Profile.RemoveServicePrompt.Description.localization,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L.Profile.RemoveServicePrompt.Delete.localization, style: .destructive) { [weak self] action in
                    self?.viewModel.removeLinkedAccount(linkedAccount: linkedAccount)
                })
                alert.addAction(UIAlertAction(title: L.Profile.RemoveServicePrompt.Cancel.localization, style: .cancel) { _ in
                    alert.dismiss(animated: true)
                })
                self?.present(alert, animated: true)
            }
            topStackView.addArrangedSubview(actionableControl)
            actionableControl.width(to: topStackView)
        }
        
        if viewModel.personalInfo.linkedAccounts?.isEmpty != false {
            // Placeholder button for adding a role
            let addInstitutionTitle = NSMutableAttributedString(string: "\(L.NameOverview.NotAvailable.localization)\n\(L.NameOverview.ProceedToAdd.localization)", attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .grayGhost, lineSpacing: 6))
            addInstitutionTitle.setAttributeTo(part: L.NameOverview.ProceedToAdd.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProItalic(size: 12), color: .grayGhost, lineSpacing: 6))
            addInstitutionButton = ActionableControlWithBodyAndTitle(
                attributedBodyText: addInstitutionTitle,
                iconInBody: UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate).withTintColor(.grayGhost),
                isFilled: false
            )
            addInstitutionButton!.addTarget(self, action: #selector(addInstitutionControlClicked), for: .touchUpInside)
            topStackView.addArrangedSubview(addInstitutionButton!)
            addInstitutionButton!.width(to: topStackView)
        }
        
        
        topStackView.setCustomSpacing(16, after: mainTitle)
        topStackView.addArrangedSubview(bottomSpacer)
        scrollView.addSubview(topStackView)
        topStackView.edges(to: scrollView, insets: TinyEdgeInsets(top: 36, left: 24, bottom: 24, right: -24))
        topStackView.width(to: scrollView, offset: -48)

        nameControl.width(to: topStackView)
    }
    
    @objc func addInstitutionControlClicked() {
        self.addInstitutionButton?.isEnabled = false
        self.addInstitutionButton?.isLoading = true
        Task {
            do {
                let link = try await self.viewModel.getStartLinkAccount()
                if let urlString = link?.url,
                   let url = URL(string: urlString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let alert = UIAlertController(
                        title: L.Generic.RequestError.Title.localization,
                        message: L.Profile.AccountLinkError.Title.localization,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                        alert.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            } catch {
                NSLog("Unable to fetch account link flow URL: \(error)")
                let alert = UIAlertController(
                    title: L.Generic.RequestError.Title.localization,
                    message: L.Generic.RequestError.Description(args: error.localizedDescription).localization,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self.present(alert, animated: true)
            }
            self.addInstitutionButton?.isLoading = false
            self.addInstitutionButton?.isEnabled = true
        }
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBackToInfoScreen(updateData: viewModel.didUpdateData)
    }
}
