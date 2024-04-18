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
    
    var screenType: ScreenType = .confirmDeleteServiceScreen
    
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
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
        // Remove any previous views
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let serviceName = viewModel.service.serviceName ?? viewModel.service.serviceNameNl ?? "?"
        
        let mainTitle = UILabel.posterTextLabelBicolor(text: L.DeleteService.Title.localization + serviceName, size: 24, primary: serviceName)
        
        let description = UILabel.plainTextLabelPartlyBold(
            text: L.DeleteService.Description.localization,
            partBold: ""
        )

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
        
        let stack = UIStackView(arrangedSubviews: [
            mainTitle,
            description,
            bottomButtonStack
        ])
        
        stack.setCustomSpacing(24, after: description)
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        
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
