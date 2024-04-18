//
//  DeleteTokensViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 01. 18..
//

import Foundation
import UIKit
import OpenAPIClient
import TinyConstraints

class DeleteTokensViewController: UIViewController, ScreenWithScreenType {
    
    var screenType: ScreenType = .confirmDeleteTokensScreen
    
    weak var delegate: ActivityViewControllerDelegate?

    private var viewModel: DeleteTokensViewModel
    
    private var confirmButton: EduIDButton!
    private var loadingIndicator: UIActivityIndicatorView!
        
    init(viewModel: DeleteTokensViewModel) {
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
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
                
        let mainTitle = UILabel.posterTextLabelBicolor(
            text: L.RevokeAccessToken.Title.localization,
            size: 24,
            primary: L.RevokeAccessToken.Title.localization
        )
        
        let description = UILabel.plainTextLabelPartlyBold(
            text: L.RevokeAccessToken.Description(args: self.viewModel.serviceName).localization,
            partBold: ""
        )
        
        let confirmContainer = UIView()
        confirmButton = EduIDButton(type: .filledRed, buttonTitle: L.RevokeAccessToken.Button.Confirm.localization)
        confirmContainer.addSubview(confirmButton)
        confirmButton.edgesToSuperview()
        loadingIndicator = UIActivityIndicatorView()
        confirmContainer.addSubview(loadingIndicator)
        loadingIndicator.width(20)
        loadingIndicator.heightToSuperview()
        loadingIndicator.centerXToSuperview(offset: 56)
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: L.RevokeAccessToken.Button.Cancel.localization)
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [
            cancelButton, confirmContainer
        ])
        
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [mainTitle, description, bottomButtonStack])
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.setCustomSpacing(24, after: description)
        
        mainTitle.widthToSuperview()
        description.widthToSuperview()
        bottomButtonStack.widthToSuperview()
        let insetView = UIView()
        insetView.backgroundColor = .white
        insetView.layer.cornerRadius = 10
        insetView.layer.masksToBounds = true
        view.addSubview(insetView)
        insetView.addSubview(stack)
        insetView.centerYToSuperview()
        insetView.centerXToSuperview()
        insetView.widthToSuperview(offset: -48)
        stack.edgesToSuperview(insets: .uniform(24))
        confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissInfoScreen), for: .touchUpInside)
        insetView.isUserInteractionEnabled = true
        insetView.addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil)) // Catch touches
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissInfoScreen)))
    }
    
    
    @objc func confirmClicked() {
        Task {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            confirmButton.isEnabled = false
            do {
                let _ = try await viewModel.deleteTokens()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let clientId = viewModel.tokensToDelete.first?.clientId,
                       clientId == AppAuthController.shared.clientId {
                        self.delegate?.activityViewControllerDismissActivityFlow(viewController: self)
                    } else {
                        self.delegate?.goBack(from: self, shouldUpdate: true)
                    }
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
