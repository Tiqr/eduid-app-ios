//
//  SelectYourBankViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 30/09/2024.
//
import UIKit
import TinyConstraints
import OpenAPIClient

class SelectYourBankViewController: BaseViewController {
    
    var delegate: PersonalInfoViewControllerDelegate?
    
    var viewModel = SelectYourBankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .selectYourBank
        setupUI(issuers: viewModel.issuers)
        viewModel.dataAvailableClosure = { [weak self] issuers in
            self?.setupUI(issuers: issuers)
        }
        viewModel.fetchIssuerList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    func setupUI(issuers: [VerifyIssuer]?) {
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

        // - Main title
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.SelectYourBank.Title.localization, size: 24, primary:  L.Profile.Title.localization)
        
        // - Description below title
        let mainDescriptionParent = UIView()
        let mainDescription = UILabel.plainTextLabelPartlyBold(text: L.SelectYourBank.Subtitle.Full.localization, partBold: L.SelectYourBank.Subtitle.HighlightedPart.localization)
        mainDescriptionParent.addSubview(mainDescription)
        mainDescription.edges(to: mainDescriptionParent)
        
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [mainTitle, mainDescriptionParent])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        stack.width(to: scrollView, offset: 0)
        
        mainTitle.widthToSuperview(offset: -48)
        mainDescriptionParent.widthToSuperview(offset: -48)

        let loadingIndicator = UIActivityIndicatorView()
        stack.addArrangedSubview(loadingIndicator)
        loadingIndicator.height(80)
        loadingIndicator.widthToSuperview()
        loadingIndicator.startAnimating()
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
}
