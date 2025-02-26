//
//  VerifyWithIdIntroVieController.swift
//  eduID
//
//  Created by Yasser Farahi on 06/02/2025.
//

import UIKit
import TinyConstraints

protocol VerifyWithIdIntroViewControllerDelegate: AnyObject, NavigationDelegate {
    func goToVerifyWithIdInputScreen(viewController: UIViewController)
}

class VerifyWithIdIntroViewController: BaseViewController {
    
    private var stack: UIStackView!
    
    weak var delegate: VerifyWithIdIntroViewControllerDelegate?
    
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
        screenType = .verifyIdentityIntroScreen
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    private func setupUI() {
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
        
        let mainTitleFirstLine: String = L.ConfirmIdentityWithIdInput.Title.FirstLine.localization
        let mainTitleSecondLine: String = L.ConfirmIdentityWithIdInput.Title.SecondLine.localization
        let mainTitleSting: String = "\(mainTitleFirstLine)\n\(mainTitleSecondLine)"
        
        let mainTitle: UILabel = UILabel.posterTextLabelBicolor(
            text: mainTitleSting,
            size: 24,
            primary: mainTitleFirstLine
        )
        
        let mainDescription = UILabel.subtitleLabel(text:L.ConfirmIdentityWithIdIntro.Description.ServiceDesk.localization)
        
        // - create the stackview
        stack = UIStackView(arrangedSubviews: [mainTitle, mainDescription])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        mainTitle.widthToSuperview(offset: -48)
        mainDescription.widthToSuperview(offset: -48)
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: .zero, right: 0))
        stack.width(to: scrollView, offset: 0)
        
        
        // - steps
        let followStepsHeaderLabel: UILabel = .init()
        followStepsHeaderLabel.text = L.ConfirmIdentityWithIdIntro.Description.Steps.Header.localization
        followStepsHeaderLabel.font = UIFont.sourceSansProBold(size: 18)
        
        stack.addArrangedSubview(followStepsHeaderLabel)
        followStepsHeaderLabel.widthToSuperview(offset: -48)
        
        let stepsString: [String] = [L.ConfirmIdentityWithIdIntro.Description.Steps.Step1.localization,
                                     L.ConfirmIdentityWithIdIntro.Description.Steps.Step2.localization,
                                     L.ConfirmIdentityWithIdIntro.Description.Steps.Step3.localization]
        
        var stepLabels: [UIStackView] = []
        
        for step in 0..<stepsString.count {
            
            let horizontalStack: UIStackView = .init()
            horizontalStack.axis = .horizontal
            horizontalStack.alignment = .top
            horizontalStack.distribution = .fill
            horizontalStack.spacing = 8
            
            let stepNumberLabel: UILabel = .init()
            stepNumberLabel.text = "\(step + 1)."
            stepNumberLabel.font = UIFont.sourceSansProRegular(size: 18)
            
            
            let stepLabel: UILabel = .init()
            stepLabel.text =  stepsString[step]
            stepLabel.font = UIFont.sourceSansProRegular(size: 18)
            stepLabel.numberOfLines = .zero
            
            horizontalStack.addArrangedSubview(stepNumberLabel)
            horizontalStack.addArrangedSubview(stepLabel)
            
            stepLabels.append(horizontalStack)
        }
        
        stepLabels.forEach { label in
            stack.addArrangedSubview(label)
            label.widthToSuperview(offset: -48)
        }
        
        // - spacer
        let spacer: UIView = .init()
        stack.addArrangedSubview(spacer)
        spacer.height(30)
        
        // - disclaimer container
        let disclaimerContainer: UIView = .init()
        disclaimerContainer.backgroundColor = UIColor(resource: .fallbackYellow)
        disclaimerContainer.height(320)
        stack.addArrangedSubview(disclaimerContainer)
        disclaimerContainer.widthToSuperview(offset: -48)
        
        let disclaimerMainStack: UIStackView = .init()
        disclaimerMainStack.alignment = .top
        disclaimerMainStack.distribution = .fill
        disclaimerMainStack.spacing = 20
        disclaimerContainer.addSubview(disclaimerMainStack)
        disclaimerMainStack.widthToSuperview(offset: -48)
        
        let warningImage: UIImageView = .init()
        warningImage.image = UIImage(resource: .warning)
        warningImage.height(25)
        warningImage.width(25)
        
        disclaimerMainStack.addArrangedSubview(warningImage)
        
        let validDocumentsDisclaimerLabel: UILabel = .init()
        validDocumentsDisclaimerLabel.numberOfLines = 0
        validDocumentsDisclaimerLabel.textAlignment = .left
        validDocumentsDisclaimerLabel.font = UIFont.sourceSansProRegular(size: 16)
        validDocumentsDisclaimerLabel.text = L.ConfirmIdentityWithIdIntro.ValidDocumentsDisclaimer.List.localization
        
        
        
        let disclaimerVStack: UIStackView = .init()
        disclaimerVStack.alignment = .leading
        disclaimerVStack.distribution = .fill
        disclaimerVStack.axis = .vertical
        disclaimerVStack.spacing = 20
        disclaimerMainStack.addArrangedSubview(disclaimerVStack)
        
        let validDocumentsDisclaimerLabelExtra: UILabel = .init()
        validDocumentsDisclaimerLabelExtra.numberOfLines = 0
        validDocumentsDisclaimerLabelExtra.textAlignment = .left
        validDocumentsDisclaimerLabelExtra.font = UIFont.sourceSansProRegular(size: 12)
        validDocumentsDisclaimerLabelExtra.text = L.ConfirmIdentityWithIdIntro.ValidDocumentsDisclaimer.Asterisk.localization
        
        
        disclaimerVStack.addArrangedSubview(validDocumentsDisclaimerLabel)
        disclaimerVStack.addArrangedSubview(validDocumentsDisclaimerLabelExtra)
        disclaimerMainStack.center(in: disclaimerContainer)
        
        stack.setCustomSpacing(80, after: disclaimerContainer)
        
        // - enter details button
        let enterDetailsButton = EduIDButton(type: .primary, buttonTitle: L.ConfirmIdentityWithIdIntro.EnterDetailsButton.localization)
        enterDetailsButton.addTarget(self, action: #selector(onEnterDetailsButtonTapped), for: .touchUpInside)
        stack.addArrangedSubview(enterDetailsButton)
        enterDetailsButton.widthToSuperview(offset: -48)
        enterDetailsButton.bottom(to: scrollView, offset: view.safeAreaInsets.bottom)
        
    }
    
    @objc private func dismissInfoScreen() {
        delegate?.goBack(viewController: self)
    }
    
    @objc private func onEnterDetailsButtonTapped() {
        delegate?.goToVerifyWithIdInputScreen(viewController: self)
    }
    
}
