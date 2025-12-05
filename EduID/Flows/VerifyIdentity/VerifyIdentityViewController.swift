//
//  VerifyIdentityViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 30/09/2024.
//
import UIKit
import TinyConstraints

class VerifyIdentityViewController: BaseViewController {
    
    private var stack: UIStackView!
        
    var viewModel: VerifyIdentityViewModel!
    
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .verifyIdentityScreen
        
        view.backgroundColor = .white
        
        setupUI()
        
        viewModel.dataFetchErrorClosure = { [weak self] eduidError in
            guard let self else { return }
            let alert = UIAlertController(title: eduidError.title, message: eduidError.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { _ in
                alert.dismiss(animated: true) {
                    if eduidError.statusCode == 401 {
                        guard let navigationController = self.navigationController else {
                            assertionFailure("Navigation controller could not be found!")
                            return
                        }
                        AppAuthController.shared.authorize(navigationController: navigationController)
                        self.dismiss(animated: false)
                        // Go back
                        self.delegate?.goBackToInfoScreen(updateData: true)
                    } else if eduidError.statusCode == -1 {
                        self.dismiss(animated: true)
                    }
                }
            })
            self.present(alert, animated: true)
        }
        viewModel.openLinkingURLClosure = { [weak self] url in
            self?.delegate?.openInWebView(url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    //MARK: - setup UI
    func setupUI() {
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.VerifyIdentity.Title.localization, size: 24, primary: L.VerifyIdentity.Title.localization)
        
        // Description below title
        let mainDescriptionParent = UIView()
        let mainDescription = UILabel.subtitleLabel(text: L.VerifyIdentity.Subtitle.localization)
        mainDescriptionParent.addSubview(mainDescription)
        mainDescription.edges(to: mainDescriptionParent)
        
        // Verify via institution
        let verifyInstitutionText = UILabel.subtitleLabel(
            text: L.VerifyIdentity.DoYouOwnAnAccount.Text.localization,
            partBold: L.VerifyIdentity.DoYouOwnAnAccount.BoldPart.localization
        )
        let verifyInstitutionButton = VerifyIdentityButton(
            title: L.VerifyIdentity.DoYouOwnAnAccount.Button.localization,
            icon: nil,
            highlighted: true,
            clickHandler: { [weak self] control in
                self?.viewModel.startLinkingInstitution(control)
            })
        let verifyInstitutionControl = UIStackView(arrangedSubviews: [verifyInstitutionText, verifyInstitutionButton])
        verifyInstitutionText.widthToSuperview(offset: -20)
        verifyInstitutionButton.widthToSuperview(offset: -20)
        verifyInstitutionControl.axis = .vertical
        verifyInstitutionControl.translatesAutoresizingMaskIntoConstraints = false
        verifyInstitutionControl.distribution = .fill
        verifyInstitutionControl.alignment = .center
        verifyInstitutionControl.spacing = 16
        verifyInstitutionControl.layoutMargins = .vertical(20)
        verifyInstitutionControl.isLayoutMarginsRelativeArrangement = true
        verifyInstitutionControl.layer.backgroundColor = UIColor.primaryColor.withAlphaComponent(0.2).cgColor
        verifyInstitutionControl.layer.cornerRadius = 4
        
        // If you don't own an account
        let dontOwnAccountText = UILabel.subtitleLabel(
            text: L.VerifyIdentity.IfYouDontOwnAnAccount.Text.localization,
            partBold: L.VerifyIdentity.IfYouDontOwnAnAccount.BoldPart.localization
        )
        
        // Verify with banking app
        let verifyWithBankingAppButton = VerifyIdentityButton(
            title: L.VerifyIdentity.Button.UseADutchBank.localization,
            icon: .verifyButtonIdin,
            highlighted: false,
            clickHandler: { [weak self] _ in
                guard let self else {
                    return
                }
                self.delegate?.goToSelectYourBankScreen(viewController: self)
                
            })
        // Verify via EU ID
        let verifyWithEuIdButton = VerifyIdentityButton(
            title: L.VerifyIdentity.Button.UseAEuropeanId.localization,
            icon: .verifyButtonEidas,
            highlighted: false,
            clickHandler: { [weak self] control in
                guard let self else {
                    return
                }
                self.viewModel.openEidasLink(control)
            })
        
        // Contact support
        let contactSupportButton = VerifyIdentityButton(
            title: L.VerifyIdentity.Button.ContactServiceDesk.localization,
            icon: .verifyContactSupport,
            highlighted: false,
            clickHandler: { [weak self] control in
                guard let self else {
                    return
                }
                self.onVisitSupportTapped()
            })
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle, mainDescriptionParent, verifyInstitutionControl, dontOwnAccountText])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        stack.addArrangedSubview(verifyWithBankingAppButton)
        stack.addArrangedSubview(verifyWithEuIdButton)
        stack.addArrangedSubview(contactSupportButton)

        stack.width(to: scrollView, offset: 0)
        
        mainTitle.widthToSuperview(offset: -48)
        mainDescriptionParent.widthToSuperview(offset: -48)
        verifyInstitutionControl.widthToSuperview(offset: -48)
        dontOwnAccountText.widthToSuperview(offset: -48)
        verifyWithBankingAppButton.widthToSuperview(offset: -48)
        verifyWithEuIdButton.widthToSuperview(offset: -48)
        contactSupportButton.widthToSuperview(offset: -48)
        stack.setCustomSpacing(44, after: verifyInstitutionControl)
        stack.edges(to: scrollView, insets: .init(top: 24, left: .zero, bottom: -view.safeAreaInsets.bottom + 20, right: .zero))
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc func onVisitSupportTapped() {
        if let supportUrl = URL(string: L.VerifyIdentity.SupportLink.localization) {
            UIApplication.shared.open(supportUrl)
        }
    }
    
    @objc private func onFallbackButtonTapped() {
        delegate?.goToVerifyIdentityIntroScreen(viewController: self)
    }
}
