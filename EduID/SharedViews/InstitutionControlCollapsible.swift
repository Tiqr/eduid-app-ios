import UIKit
import TinyConstraints

class InstitutionControlCollapsible: ExpandableControl {

    private var removeAction: () -> Void
    
    var institution: String
    
    //MARK: - init
    init(
        institution: String,
        verifiedAt: Date?,
        affiliation: String,
        expires: Date?,
        removeAction: @escaping () -> Void
    ) {
        self.institution = institution
        self.removeAction = removeAction
        super.init()
        
        let role: String
        if affiliation.contains("@") {
            role = affiliation.components(separatedBy: "@")[0]
        } else {
            role = affiliation
        }
        
        let iconEmoji = role.lowercased() == L.Profile.Employee.localization ? "🏢️" : "🧑‍🎓"
        let title = "\(iconEmoji) \(role.capitalized)"
        setupUI(title: title, institution: institution, verifiedAt: verifiedAt, affiliation: affiliation, expires: expires)
    }
    
    init(title: String, institution: String, verifiedAt: Date?, affiliation: String, expires: Date?, removeAction: @escaping () -> Void) {
        self.institution = institution
        self.removeAction = removeAction
        super.init()
        setupUI(title: title, institution: institution, verifiedAt: verifiedAt, affiliation: affiliation, expires: expires)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
            
    //MARK: - setup UI
    func setupUI(title: String, institution: String, verifiedAt: Date?, affiliation: String, expires: Date?) {
        
        backgroundColor = .white
        
        //body stackview
        let attributedStringBody = NSMutableAttributedString()
        attributedStringBody.append(NSAttributedString(string: title, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .backgroundColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: L.Profile.InstitutionAt.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .secondaryColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: institution, attributes:AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 12), color: .alertsInformationColor, lineSpacing: 6)))
        let bodyParent = UIView()
        let bodyLabel = UILabel()
        bodyParent.addSubview(bodyLabel)
        bodyLabel.edges(to: bodyParent)
        bodyLabel.numberOfLines = 0
        bodyLabel.attributedText = attributedStringBody
        
        self.chevronImage = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        self.chevronImage.tintColor = .backgroundColor
        self.chevronImage.size(CGSize(width: 24, height: 24))
        
        let bodyStack = UIStackView(arrangedSubviews: [bodyParent, self.chevronImage])
        bodyStack.alignment = .center
        bodyStack.height(50)
        
        // verfied by
        let verifiedParent = UIView()
        let verifiedLabel = UILabel()
        verifiedLabel.numberOfLines = 0
        verifiedParent.addSubview(verifiedLabel)
        verifiedLabel.edges(to: verifiedParent)
        let verifiedBy = NSMutableAttributedString(string: L.Profile.VerifiedBy(args: institution).localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        let verifiedOnString: String
        if let verifiedAt = verifiedAt {
            verifiedOnString = L.Profile.VerifiedOn(args: InstitutionControlCollapsible.dateFormatter.string(from: verifiedAt)).localization
        } else {
            verifiedOnString = L.Profile.VerifiedOn(args: "?").localization
        }
        let verifiedOn = NSMutableAttributedString(string: verifiedOnString, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        verifiedBy.append(verifiedOn)
        verifiedLabel.attributedText = verifiedBy
        
        // line 2
        let line2 = UIView()
        line2.height(1)
        line2.backgroundColor = .backgroundColor
        
        // Institution
        let institutionlabelLabel = UILabel()
        let institutionlabelAttributedString = NSAttributedString(string: L.Profile.Institution.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        institutionlabelLabel.attributedText = institutionlabelAttributedString
        
        let institutionLabel = UILabel()
        let institutionLabelAttributedString = NSAttributedString(string: institution, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        institutionLabel.attributedText = institutionLabelAttributedString
        
        let institutionStack = UIStackView(arrangedSubviews: [institutionlabelLabel, institutionLabel])
        institutionStack.axis = .horizontal
        institutionStack.distribution = .fillEqually
        
        // line 3
        let line3 = UIView()
        line3.height(1)
        line3.backgroundColor = .backgroundColor
        
        // Affiliations
        let affiliationslabelLabel = UILabel()
        let affiliationslabelAttributedString = NSAttributedString(string: L.Profile.Affiliations.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        affiliationslabelLabel.attributedText = affiliationslabelAttributedString
        
        let affiliationsLabel = UILabel()
        let affiliationsLabelAttributedString = NSAttributedString(string: affiliation, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        affiliationsLabel.attributedText = affiliationsLabelAttributedString
        
        let affiliationsStack = UIStackView(arrangedSubviews: [affiliationslabelLabel, affiliationsLabel])
        affiliationsStack.axis = .horizontal
        affiliationsStack.distribution = .fillEqually
        
        // line 4
        let line4 = UIView()
        line4.height(1)
        line4.backgroundColor = .backgroundColor
        
        // link expires
        let expireslabelLabel = UILabel()
        let expireslabelAttributedString = NSAttributedString(string: L.Profile.Expires.localization, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 14), color: .secondaryColor, lineSpacing: 6))
        expireslabelLabel.attributedText = expireslabelAttributedString
        
        let expiresLabel = UILabel()
        let expiresString: String
        if let expires = expires {
            expiresString = InstitutionControlCollapsible.dateFormatter.string(from: expires)
        } else {
            expiresString = "?"
        }
        let expiresLabelAttributedString = NSAttributedString(string: expiresString, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 14), color: .secondaryColor, lineSpacing: 6))
        expiresLabel.attributedText = expiresLabelAttributedString
        
        let expiresStack = UIStackView(arrangedSubviews: [expireslabelLabel, expiresLabel])
        expiresStack.axis = .horizontal
        expiresStack.distribution = .fillEqually
        
        // line 5
        let line5 = UIView()
        line5.height(1)
        line5.backgroundColor = .backgroundColor
        
        // remove button
        let button = EduIDButton(type: .borderedRed, buttonTitle: L.Institution.Delete.localization)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [bodyStack, verifiedParent, line2, institutionStack, line3, affiliationsStack, line4, expiresStack, line5, button])
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
    
    @objc
    func buttonAction() {
        removeAction()
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
}
