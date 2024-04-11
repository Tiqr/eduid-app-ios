//
//  VerifiedInformationControlCollapsible.swift
//  eduID
//
//  Created by Dániel Zolnai on 11/04/2024.
//
import UIKit
import TinyConstraints
import OpenAPIClient

class VerifiedInformationControlCollapsible: UIControl {

    private var stack: UIStackView!
    private var isExpanded = false
    private var manageVerifiedInformationAction: () -> Void
    
    //MARK: - init
    init(title: String,
         subtitle: String,
         linkedAccount: LinkedAccount,
         manageVerifiedInformationAction: @escaping () -> Void
    ) {
        self.manageVerifiedInformationAction = manageVerifiedInformationAction
        super.init(frame: .zero)
        setupUI(title: title, subtitle: subtitle, linkedAccount: linkedAccount)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
            
    //MARK: - setup UI
    private func setupUI(title: String, subtitle: String, linkedAccount: LinkedAccount) {
        backgroundColor = .white
        //body stackview
        let attributedStringBody = NSMutableAttributedString()
        attributedStringBody.append(NSAttributedString(string: title, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .backgroundColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: subtitle, attributes:AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .grayGhost, lineSpacing: 6)))
        let bodyParent = UIView()
        let bodyLabel = UILabel()
        bodyParent.addSubview(bodyLabel)
        bodyLabel.edges(to: bodyParent)
        bodyLabel.numberOfLines = 0
        bodyLabel.attributedText = attributedStringBody
        
        let shieldImageView = UIImageView()
        shieldImageView.image = .shield
        shieldImageView.size(CGSize(width: 24, height: 28))
        
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevronImage.tintColor = .backgroundColor
        chevronImage.size(CGSize(width: 24, height: 24))
        
        let bodyStack = UIStackView(arrangedSubviews: [shieldImageView, bodyParent, chevronImage])
        bodyStack.setCustomSpacing(12, after: shieldImageView)
        bodyStack.alignment = .center
        bodyStack.height(50)
        
        // Line 1
        let line1 = UIView()
        line1.height(2)
        line1.backgroundColor = .backgroundColor
        
        // Verified by
        let verifiedByLabel = UILabel()
        let bulletPoint = " • "
        let verifiedByString = NSMutableAttributedString(
            string: L.Profile.VerifiedBy(args: linkedAccount.schacHomeOrganization ?? linkedAccount.institutionIdentifier ?? "").localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 12), color: .grayGhost, lineSpacing: 6)
        )
        if let createdAt = linkedAccount.createdAt {
            let createdAtDate = Date(timeIntervalSince1970: TimeInterval(createdAt / 1000))
            verifiedByString.append(NSAttributedString(
                string: "\n" + bulletPoint + L.Profile.LinkedAccountCreatedAt.localization,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .grayGhost, lineSpacing: 6)
            ))
            verifiedByString.append(NSAttributedString(
                string: VerifiedInformationControlCollapsible.dateFormatter.string(from: createdAtDate),
                attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 12), color: .grayGhost, lineSpacing: 6)
            ))
        }
        if let expiresAt = linkedAccount.expiresAt {
            let expiresAtDate = Date(timeIntervalSince1970: TimeInterval(expiresAt / 1000))
            verifiedByString.append(NSAttributedString(
                string: "\n" + bulletPoint + L.Profile.LinkedAccountValidUntil.localization,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .grayGhost, lineSpacing: 6)
            ))
            verifiedByString.append(NSAttributedString(
                string: VerifiedInformationControlCollapsible.dateFormatter.string(from: expiresAtDate),
                attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 12), color: .grayGhost, lineSpacing: 6)
            ))
        }
        
        // Line 2
        let line2 = UIView()
        line2.height(2)
        line2.backgroundColor = .backgroundColor
        
        // Manage your verified information
        let manageLabel = UIButton()
        manageLabel.setAttributedTitle(NSAttributedString(
            string: L.Profile.ManageYourVerifiedInformation.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .backgroundColor, lineSpacing: 6, underline: true)
        ), for: .normal)
        manageLabel.addTarget(self, action: #selector(manageVerifiedInformation), for: .touchUpInside)
        manageLabel.contentHorizontalAlignment = .left
        
        verifiedByLabel.attributedText = verifiedByString
        verifiedByLabel.numberOfLines = 0
        let bottomStack = UIStackView(arrangedSubviews: [line1, verifiedByLabel, line2, manageLabel])
        bottomStack.axis = .vertical
        bottomStack.spacing = 18
        bottomStack.distribution = .equalSpacing
        bottomStack.isLayoutMarginsRelativeArrangement = true
        bottomStack.layoutMargins = .left(36)
                        
        stack = UIStackView(arrangedSubviews: [bodyStack, bottomStack])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 18
        
        addSubview(stack)
        stack.edges(to: self, insets: TinyEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
        
        //border
        layer.borderWidth = 2
        layer.borderColor = UIColor.backgroundColor.cgColor
        layer.cornerRadius = 6
        
        // initially hide elements
        for i in (1..<stack.arrangedSubviews.count) {
            stack.arrangedSubviews[i].isHidden = true
            stack.arrangedSubviews[i].alpha = 0
        }
    }
    
    //MARK: - expand or contract action
    @objc
    func expandOrContract() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            for i in (1..<(self?.stack.arrangedSubviews.count ?? 0)) {
                self?.stack.arrangedSubviews[i].isHidden = self?.isExpanded ?? true
                self?.stack.arrangedSubviews[i].alpha = (self?.isExpanded ?? true) ? 0 : 1
            }
        }
        isExpanded.toggle()
    }
    
    @objc
    func manageVerifiedInformation() {
        self.manageVerifiedInformationAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
}

