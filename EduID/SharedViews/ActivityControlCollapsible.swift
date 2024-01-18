import UIKit
import SDWebImage
import TinyConstraints
import OpenAPIClient

class ActivityControlCollapsible: UIControl {

    private var stack: UIStackView!
    private var isExpanded = false
    private var callbackRemoveDetailsButtonAction: () -> Void
    private var callbackRevokeTokenButtonAction: (Token) -> Void
    
    private var tokens: [Token]
        
    //MARK: - init
    init(
        logoImageURL: String,
        institutionTitle: String,
        date: Date,
        uniqueId: String,
        accessTokens: [Token],
        removeDetailsButtonAction: @escaping () -> Void,
        revokeTokenButtonAction: @escaping (Token) -> Void
    ) {
        self.callbackRemoveDetailsButtonAction = removeDetailsButtonAction
        self.callbackRevokeTokenButtonAction = revokeTokenButtonAction
        self.tokens = accessTokens
        super.init(frame: .zero)
        
        setupUI(
            logoImageURL: logoImageURL,
            institutionTitle: institutionTitle,
            date: date,
            uniqueId: uniqueId,
            accessTokens: accessTokens
        )
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
            
    //MARK: - setup UI
    func setupUI(logoImageURL: String, institutionTitle: String, date: Date, uniqueId: String, accessTokens: [Token]) {
        
        backgroundColor = .disabledGrayBackground
        
        //body stackview
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: URL(string: logoImageURL))
        imageView.size(CGSize(width: 42, height: 42))
        
        let hourTimeFormatter = DateFormatter()
        hourTimeFormatter.dateFormat = "HH:mm"
        let attributedStringBody = NSMutableAttributedString()
        attributedStringBody.append(NSAttributedString(string: institutionTitle, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .secondaryColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: "\(L.DataActivity.Details.On.localization) \(InstitutionControlCollapsible.dateFormatter.string(from: date)) - \(hourTimeFormatter.string(from: date))", attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .secondaryColor, lineSpacing: 6)))
        let bodyParent = UIView()
        let bodyLabel = UILabel()
        bodyParent.addSubview(bodyLabel)
        bodyLabel.edges(to: bodyParent)
        bodyLabel.numberOfLines = 0
        bodyLabel.attributedText = attributedStringBody
        
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevronImage.tintColor = .backgroundColor
        chevronImage.size(CGSize(width: 24, height: 24))
        
        let bodyStack = UIStackView(arrangedSubviews: [imageView, bodyParent, chevronImage])
        bodyStack.setCustomSpacing(8, after: imageView)
        bodyStack.alignment = .center
        bodyStack.height(50, relation: .equalOrGreater)
        
        // Login details
        let loginDetailsParent = UIView()
        let loginDetailsLabel = UILabel()
        loginDetailsLabel.numberOfLines = 0
        loginDetailsParent.addSubview(loginDetailsLabel)
        loginDetailsLabel.edges(to: loginDetailsParent)
        let verifiedFormatted = L.DataActivity.Details.Login.localization
        let verifiedAttributedString = NSMutableAttributedString(string: verifiedFormatted, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        loginDetailsLabel.attributedText = verifiedAttributedString
        
        // line 2
        let line2 = UIView()
        line2.height(1)
        line2.backgroundColor = .backgroundColor
        
        // institution
        let firstLoginlabelLabel = UILabel()
        let institutionlabelAttributedString = NSAttributedString(string: L.DataActivity.Details.FirstLogin.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        firstLoginlabelLabel.attributedText = institutionlabelAttributedString
        
        let firstLoginLabel = UILabel()
        let firstLoginLabelAttributedString = NSAttributedString(string: InstitutionControlCollapsible.dateFormatter.string(from: date) , attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        firstLoginLabel.attributedText = firstLoginLabelAttributedString
        firstLoginLabel.numberOfLines = .zero
        let firstLoginStack = UIStackView(arrangedSubviews: [firstLoginlabelLabel, firstLoginLabel])
        firstLoginStack.axis = .horizontal
        firstLoginStack.distribution = .fillEqually
        
        // line 3
        let line3 = UIView()
        line3.height(1)
        line3.backgroundColor = .backgroundColor
        
        // affiliations
        let uniqueIdLabelLabel = UILabel()
        let uniqueIdLabelAttributedString = NSAttributedString(string: L.DataActivity.Details.UniqueEduID.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        uniqueIdLabelLabel.attributedText = uniqueIdLabelAttributedString
        
        let uniqueIdLabel = UILabel()
        uniqueIdLabel.numberOfLines = 0
        let uniqueIdAttributedString = NSAttributedString(string: uniqueId, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        uniqueIdLabel.attributedText = uniqueIdAttributedString
        
        let uniqueIdStack = UIStackView(arrangedSubviews: [uniqueIdLabelLabel, uniqueIdLabel])
        uniqueIdStack.axis = .horizontal
        uniqueIdStack.distribution = .fillEqually
        
        // line 4
        let line4 = UIView()
        line4.height(1)
        line4.backgroundColor = .backgroundColor
        
        // remove button
        let button = EduIDButton(type: .borderedRed, buttonTitle: L.DataActivity.Details.Delete.localization)
        button.addTarget(self, action: #selector(removeDetailsButtonAction), for: .touchUpInside)
        
        let disclaimerParent = UIView()
        let disclaimerText = NSMutableAttributedString(
            string: L.DataActivity.Details.DeleteDisclaimer.localization,
            attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        let disclaimerLabel = UILabel()
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.attributedText = disclaimerText
        disclaimerParent.addSubview(disclaimerLabel)
        disclaimerLabel.edges(to: disclaimerParent, insets: .bottom(10))
        
        stack = UIStackView(arrangedSubviews: [bodyStack, loginDetailsParent, line2, firstLoginStack, line3, uniqueIdStack, line4, button, disclaimerParent])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 18
        
        for accessToken in accessTokens {
            let line5 = UIView()
            line5.height(1)
            line5.backgroundColor = .backgroundColor
            
            let tokenDetailsParent = UIView()
            let tokenDetailsLabel = UILabel()
            tokenDetailsLabel.numberOfLines = 0
            tokenDetailsParent.addSubview(tokenDetailsLabel)
            tokenDetailsLabel.edges(to: tokenDetailsParent)
            let tokenDetailsString = L.DataActivity.Details.Access.localization
            let tokenDetailsAttributedString = NSMutableAttributedString(
                string: tokenDetailsString,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6)
            )
            tokenDetailsLabel.attributedText = tokenDetailsAttributedString
            
            // line 6
            let line6 = UIView()
            line6.height(1)
            line6.backgroundColor = .backgroundColor
            
            // Account details - label
            let accountDetailsLabel = UILabel()
            let accountDetailsAttributedString = NSAttributedString(string: L.DataActivity.Details.Details.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
            accountDetailsLabel.attributedText = accountDetailsAttributedString
            
            // Account details - value
            let accountDetailsValueLabel = UILabel()
            var scopesString = ""
            for scope in (accessToken.scopes ?? []) {
                let language: String
                if #available(iOS 16, *) {
                    language = Locale.current.language.languageCode?.identifier ?? "en"
                } else {
                    language = Locale.current.languageCode ?? "en"
                }
                let description = scope.descriptions?[language] ?? scope.descriptions?["en"] ?? scope.name ?? ""
                if description.count > 0 {
                    scopesString += "• \(description)\n"
                }
                scopesString = scopesString.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let accountDetailsValueString = NSAttributedString(
                string: scopesString,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6)
            )
            accountDetailsValueLabel.attributedText = accountDetailsValueString
            accountDetailsValueLabel.numberOfLines = .zero
            let accountDetailsStack = UIStackView(arrangedSubviews: [accountDetailsLabel, accountDetailsValueLabel])
            accountDetailsStack.axis = .horizontal
            accountDetailsStack.distribution = .fill
            
            // Date of consent - Label
            let dateOfConsentLabel = UILabel()
            let dateOfConsentAttributedString = NSAttributedString(string: L.DataActivity.Details.Consent.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
            dateOfConsentLabel.attributedText = dateOfConsentAttributedString
            
            // Date of consent - value
            let dateOfConsentValue = UILabel()
            let createdAtDateString: String
            if let createdAt = accessToken.createdAt,
               let createdAtDate = ActivityControlCollapsible.isoDateFormatter.date(from: createdAt) {
                createdAtDateString = InstitutionControlCollapsible.dateFormatter.string(from: createdAtDate)
            } else {
                createdAtDateString = "-"
            }
            let dateOfConsentValueAttributedString = NSAttributedString(
                string: createdAtDateString,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6)
            )
            dateOfConsentValue.attributedText = dateOfConsentValueAttributedString
            dateOfConsentValue.numberOfLines = .zero
            let dateOfConsentStack = UIStackView(arrangedSubviews: [dateOfConsentLabel, dateOfConsentValue])
            dateOfConsentStack.axis = .horizontal
            dateOfConsentStack.distribution = .fill
            
            // Expire date - label
            let expireDateLabel = UILabel()
            let expireDateAttributedString = NSAttributedString(string: L.DataActivity.Details.Expires.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
            expireDateLabel.attributedText = expireDateAttributedString
            
            // Expire date - value
            let expireDateValue = UILabel()
            let expireDateString: String
            if let expiresIn = accessToken.expiresIn,
               let expiresInDate = ActivityControlCollapsible.isoDateFormatter.date(from: expiresIn) {
                expireDateString = InstitutionControlCollapsible.dateFormatter.string(from: expiresInDate)
            } else {
                expireDateString = "-"
            }
            let expireDateValueAttributedString = NSAttributedString(
                string: expireDateString,
                attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6)
            )
            expireDateValue.attributedText = expireDateValueAttributedString
            expireDateValue.numberOfLines = .zero
            let expireDateStack = UIStackView(arrangedSubviews: [expireDateLabel, expireDateValue])
            expireDateStack.axis = .horizontal
            expireDateStack.distribution = .fill
            
            // revoke button
            let revokeButton = EduIDButton(type: .borderedRed, buttonTitle: L.DataActivity.Details.Revoke.localization)
            revokeButton.tag = accessTokens.firstIndex(of: accessToken) ?? 0
            revokeButton.addTarget(self, action: #selector(revokeButtonAction(sender:)), for: .touchUpInside)
            
            stack.addArrangedSubview(line5)
            stack.addArrangedSubview(tokenDetailsParent)
            stack.addArrangedSubview(accountDetailsStack)
            stack.addArrangedSubview(dateOfConsentStack)
            stack.addArrangedSubview(expireDateStack)
            stack.addArrangedSubview(revokeButton)
            
            accountDetailsLabel.widthAnchor.constraint(equalTo: accountDetailsStack.widthAnchor, multiplier: 0.4).isActive = true
            dateOfConsentLabel.widthAnchor.constraint(equalTo: dateOfConsentStack.widthAnchor, multiplier: 0.4).isActive = true
            expireDateLabel.widthAnchor.constraint(equalTo: expireDateStack.widthAnchor, multiplier: 0.4).isActive = true
        }
        
        addSubview(stack)
        stack.edges(to: self, insets: TinyEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
        
        //border
        layer.borderWidth = 3
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
    func removeDetailsButtonAction() {
        self.callbackRemoveDetailsButtonAction()
    }
    
    @objc
    func revokeButtonAction(sender: UIButton) {
        let tokenToDelete = tokens[sender.tag]
        self.callbackRevokeTokenButtonAction(tokenToDelete)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    static var isoDateFormatter = CodableHelper.dateFormatter
    
}
