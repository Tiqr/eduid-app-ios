//
//  LinkingSuccessViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 10..
//
import OpenAPIClient
import UIKit
import TinyConstraints

class LinkingSuccessViewController: BaseViewController {
    
    var delegate: PersonalInfoViewControllerDelegate?
    
    var viewModel = LinkingSuccessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .linkingSuccessScreen
        setupUI(viewModel.userResponse)
        viewModel.dataHandler = { [weak self] result in
            if case .success(let userResponse) = result {
                self?.setupUI(userResponse)
            } else if case .failure(let error) = result {
                self?.handleError(error)
            }
        }
        viewModel.getData()
    }
    
    private func handleError(_ error: Error) {
        let errorTitle = (error as? EduIdError)?.title ?? error.localizedFromApi
        let errorMessage = (error as? EduIdError)?.message ?? error.localizedDescription
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.PinAndBioMetrics.OKButton.localization, style: .default) { _ in
            alert.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        })
        self.present(alert, animated: true)
      }
    
    func setupUI(_ userResponse: UserResponse?) {
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
        let mainTitle = UILabel.posterTextLabelBicolor(
            text: L.SelectYourBank.Title.localization,
            size: 24,
            primary: L.SelectYourBank.Title.localization
        )
        
        // - Description below title
        let mainDescriptionParent = UIView()
        let mainDescription = UILabel.subtitleLabel(
            text: L.SelectYourBank.Subtitle.Full.localization, // TODO use correct title and message
            partBold: L.SelectYourBank.Subtitle.HighlightedPart.localization
        )
        mainDescriptionParent.addSubview(mainDescription)
        mainDescription.edges(to: mainDescriptionParent)
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [mainTitle, mainDescriptionParent])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 24
        scrollView.addSubview(stack)
        
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        stack.width(to: scrollView, offset: 0)
        stack.setCustomSpacing(4, after: mainDescriptionParent)
        
        mainTitle.widthToSuperview(offset: -48)
        mainDescriptionParent.widthToSuperview(offset: -48)
        
        if userResponse != nil {
            // TODO
        } else {
            let loadingIndicator = UIActivityIndicatorView()
            stack.addArrangedSubview(loadingIndicator)
            loadingIndicator.height(80)
            loadingIndicator.widthToSuperview()
            loadingIndicator.startAnimating()
        }
    }
    
}
    
    
