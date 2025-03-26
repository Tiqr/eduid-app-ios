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
        
        let mainTitleFirstLine: String = L.ConfirmIdentityWithIdIntro.Title.FirstLine.localization
        let mainTitleSecondLine: String = L.ConfirmIdentityWithIdIntro.Title.SecondLine.localization
        let mainTitleString: String = "\(mainTitleFirstLine)\n\(mainTitleSecondLine)"
        
        let mainTitle: UILabel = UILabel.posterTextLabelBicolor(
            text: mainTitleString,
            size: 24,
            primary: mainTitleFirstLine
        )
        
        let mainDescription = UILabel.subtitleLabel(text:L.ServiceDesk.ConfirmIdentity.localization)
        
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
        let followStepsHeaderLabel: UILabel = createUILabel(text: L.ServiceDesk.StepsHeader.localization, font: UIFont.sourceSansProBold(size: 18))
        
        stack.addArrangedSubview(followStepsHeaderLabel)
        followStepsHeaderLabel.widthToSuperview(offset: -48)
        
        let stepsString: [String] = [L.ServiceDesk.Step1.localization,
                                     L.ServiceDesk.Step2.localization,
                                     L.ServiceDesk.Step3.localization]
        
        var stepLabels: [UIStackView] = []
        
        for step in 0..<stepsString.count {
            
            let horizontalStack: UIStackView = .init()
            horizontalStack.axis = .horizontal
            horizontalStack.alignment = .top
            horizontalStack.distribution = .fill
            horizontalStack.spacing = 5
            
            let stepNumberLabel: UILabel = .init()
            stepNumberLabel.textAlignment = .left
            stepNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            stepNumberLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
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
        
        let validDocumentsDisclaimerLabel: UILabel = createUILabel(text: L.ServiceDesk.AcceptedIds.localization,
                                                                   font: UIFont.sourceSansProRegular(size: 16))

        let disclaimerVStack: UIStackView = .init()
        disclaimerVStack.alignment = .leading
        disclaimerVStack.distribution = .fill
        disclaimerVStack.axis = .vertical
        disclaimerVStack.spacing = .zero
        disclaimerMainStack.addArrangedSubview(disclaimerVStack)
        
        let validDocumentsDisclaimerLabelExtra: UILabel = createUILabel(attributedText: L.ServiceDesk.EeaNote.localization.htmlAttributedString(fontFamily: "SourceSansPro-Regular",fontSize: 12))
        let passportLabel: UILabel = createUILabel(text: "- \(L.ServiceDesk.Passports.localization)")
        let eeaIDCardLabel: UILabel = createUILabel(attributedText: "\("- " + L.ServiceDesk.Eea.localization)".htmlAttributedString(fontFamily: "SourceSansPro-Regular", fontSize: 16))
        let dutchDriversLicensesLabel: UILabel = createUILabel(text: "- \(L.ServiceDesk.DriverLicense.localization)")
        let dutchResidencePermitsLabel: UILabel = createUILabel(text: "- \(L.ServiceDesk.ResidencePermit.localization)")
        let disclaimerNoteLabel: UILabel = createUILabel(text: L.ServiceDesk.Note.localization)
        
        disclaimerVStack.addArrangedSubview(validDocumentsDisclaimerLabel)
        disclaimerVStack.addArrangedSubview(passportLabel)
        disclaimerVStack.addArrangedSubview(eeaIDCardLabel)
        disclaimerVStack.addArrangedSubview(dutchDriversLicensesLabel)
        disclaimerVStack.addArrangedSubview(dutchResidencePermitsLabel)
        disclaimerVStack.addArrangedSubview(disclaimerNoteLabel)
        disclaimerVStack.addArrangedSubview(validDocumentsDisclaimerLabelExtra)
        disclaimerMainStack.center(in: disclaimerContainer)
        
        disclaimerVStack.setCustomSpacing(20, after: dutchResidencePermitsLabel)
        disclaimerVStack.setCustomSpacing(20, after: disclaimerNoteLabel)
        stack.setCustomSpacing(80, after: disclaimerContainer)
        
        // - enter details button
        let enterDetailsButton = EduIDButton(type: .primary, buttonTitle: L.ServiceDesk.Next.localization)
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
    
    private func createUILabel(text: String? = nil,
                               attributedText: NSMutableAttributedString? = nil,
                               font: UIFont = UIFont.sourceSansProRegular(size: 16)) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textAlignment = .left
        label.numberOfLines = 0
        if let text {
            label.text = text
        }
        if let attributedText {
            label.attributedText = attributedText
        }
        return label
    }
    
}
