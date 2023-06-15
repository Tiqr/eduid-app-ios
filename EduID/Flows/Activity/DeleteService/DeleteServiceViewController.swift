//
//  DeleteServiceViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation
import UIKit
import OpenAPIClient
import TinyConstraints

class DeleteServiceViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .confirmDeleteScreen
    
    weak var delegate: ActivityViewControllerDelegate?

    private var viewModel: DeleteServiceViewModel
    
    private var confirmButton: EduIDButton!
    private var loadingIndicator: UIActivityIndicatorView!
    
    init(viewModel: DeleteServiceViewModel) {
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
        
        let serviceName = viewModel.service.serviceName ?? viewModel.service.serviceNameNl ?? "?"
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.DeleteService.Title.localization, size: 24, primary: L.DeleteService.Title.localization)
            

        let disclaimerContainer = UIView()
        let disclaimerLabel = UILabel()
        let errorImage = UIImageView()
        errorImage.image = .error
        errorImage.size(CGSize(width: 22.5, height: 21))
        let disclaimerString = NSMutableAttributedString(
            string: L.DeleteService.Disclaimer.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .charcoalColor, lineSpacing: 4)
        )
        disclaimerLabel.attributedText = disclaimerString
        disclaimerContainer.addSubview(disclaimerLabel)
        disclaimerContainer.addSubview(errorImage)
        errorImage.leftToSuperview(offset: 12)
        errorImage.topToSuperview(offset: 18)
        disclaimerLabel.leftToRight(of: errorImage, offset: 12)
        disclaimerLabel.rightToSuperview(offset: -12)
        disclaimerLabel.verticalToSuperview(insets: .vertical(12))
        disclaimerLabel.numberOfLines = 0
        disclaimerContainer.backgroundColor = UIColor.alertsBackgroundColor
        
        let description = UILabel.plainTextLabelPartlyBold(
            text: L.DeleteService.Description(args: serviceName).localization,
            partBold: ""
        )
                
        let topStackView = UIStackView(arrangedSubviews: [
            mainTitle,
            disclaimerContainer,
            description
        ])
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        let confirmContainer = UIView()
        confirmButton = EduIDButton(type: .filledRed, buttonTitle: L.DeleteService.Button.Confirm.localization)
        confirmContainer.addSubview(confirmButton)
        confirmButton.edgesToSuperview()
        loadingIndicator = UIActivityIndicatorView()
        confirmContainer.addSubview(loadingIndicator)
        loadingIndicator.width(20)
        loadingIndicator.heightToSuperview()
        loadingIndicator.centerXToSuperview(offset: 56)
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.DeleteService.Button.Cancel.localization)
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [
            cancelButton, confirmContainer
        ])
        
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.distribution = .fillEqually
        
        topStackView.addArrangedSubview(spacer)
        topStackView.addArrangedSubview(bottomButtonStack)
        
        topStackView.alignment = .leading
        topStackView.axis = .vertical
        topStackView.distribution = .fill
        topStackView.spacing = 16
        
        mainTitle.widthToSuperview()
        disclaimerContainer.widthToSuperview()
        description.widthToSuperview()
        spacer.widthToSuperview()
        bottomButtonStack.widthToSuperview()
        
        view.addSubview(topStackView)
        topStackView.edges(to: view, insets: TinyEdgeInsets(top: 80, left: 24, bottom: 24, right: 24))
        confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
    }
    
    
    @objc func confirmClicked() {
        Task {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            confirmButton.isEnabled = false
            do {
                let _ = try await viewModel.deleteActivity()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.goBack(from: self, shouldUpdate: true)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let alert = UIAlertController(
                        title: L.DeleteService.Error.localization,
                        message: error.localizedDescription,
                        preferredStyle: .alert)
                    alert.addAction(.init(title: L.Generic.RequestError.CloseButton.localization, style: .cancel) { _ in
                        alert.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                    self.loadingIndicator.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    self.confirmButton.isEnabled = true
                }
            }
        }
    }
    
    @objc func dismissInfoScreen() {
        delegate?.goBack(from: self, shouldUpdate: false)
    }
}
