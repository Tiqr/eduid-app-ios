//
//  TwoFactorKeysViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 19..
//

import Foundation
import UIKit
import TinyConstraints
import TiqrCoreObjC

class TwoFactorKeysViewController: UIViewController, ScreenWithScreenType {
    
    // - screen type
    var screenType: ScreenType = .securityTwoFactorKeys
    
    private let viewModel: TwoFactorKeysViewModel
    
    // - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    init(viewModel: TwoFactorKeysViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        setupUI(identities: nil)
        refreshData()
    }
    
    func refreshData() {
        Task {
            do {
                let identities = try await viewModel.getIdentityList()
                DispatchQueue.main.async { [weak self] in
                    self?.setupUI(identities: identities)
                }
            } catch {
                showError(error)
            }
        }
    }
    
    private func setupUI(identities: [Identity]?) {
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let mainTitle = UILabel.posterTextLabelBicolor(text: L.TwoFactorKeys.Title.localization, size: 24, primary: L.TwoFactorKeys.Title.localization)
        let description = UILabel.plainTextLabelPartlyBold(
            text: L.TwoFactorKeys.Description.localization,
            partBold: ""
        )
        let listHeader = UILabel()
        listHeader.attributedText = NSMutableAttributedString(
            string: L.TwoFactorKeys.YourKeys.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .charcoalColor, lineSpacing: 6)
        )
        
                
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            description,
            listHeader
        ])
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 20
        
        mainTitle.widthToSuperview()
        description.widthToSuperview()
        listHeader.widthToSuperview()
        
        if identities == nil {
            let loadingIndicator = UIActivityIndicatorView()
            topStackView.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.centerXToSuperview()
            loadingIndicator.startAnimating()
        } else if identities?.isEmpty == true {
            let emptyLabel = UILabel.plainTextLabelPartlyBold(text: L.TwoFactorKeys.NoKeys.localization, partBold: "")
            topStackView.setCustomSpacing(40, after: listHeader)
            topStackView.addArrangedSubview(emptyLabel)
            emptyLabel.textAlignment = .center
            emptyLabel.widthToSuperview()
        } else {
            identities?.forEach { identity in
                let control = TwoFactorKeyControlCollapsible(
                    identity: identity,
                    removeAction: { [weak self] in
                        self?.goToConfirmationScreen(identity)
                    },
                    biometricsValueChanged: { [weak self] isEnabled in
                        self?.viewModel.setIdentityBiometricsEnabled(identity: identity, biometricsEnabled: isEnabled)
                    })
                topStackView.addArrangedSubview(control)
                control.widthToSuperview()
            }
        }

        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
        topStackView.addArrangedSubview(spacer)

        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        scrollView.addSubview(topStackView)
        scrollView.contentInsetAdjustmentBehavior = .always
        topStackView.widthToSuperview(offset: -48)
        topStackView.edges(to: scrollView, insets: .uniform(24))
    }
    
    private func goToConfirmationScreen(_ identity: Identity) {
        delegate?.goToDeleteKeyConfirmationScreen(viewController: self, identity: identity)
    }
    
    @objc
    private func dismissInfoScreen() {
        if viewModel.didRemoveIdentities {
            delegate?.goToMainScreenWithPersonalInfo(viewModel.personalInfo)
        } else {
            delegate?.goBack(viewController: self)
        }
        
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: L.Generic.RequestError.Title.localization,
            message: L.Generic.RequestError.Description(args: error.localizedFromApi).localization,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.Generic.RequestError.CloseButton.localization, style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }
}
