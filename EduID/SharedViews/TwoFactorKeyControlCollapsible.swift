import UIKit
import TinyConstraints
import TiqrCoreObjC

class TwoFactorKeyControlCollapsible: UIControl {

    private var stack: UIStackView!
    private var isExpanded = false
    private let removeAction: () -> Void
    private let biometricsValueChanged: (Bool) -> Void
        
    //MARK: - init
    init(identity: Identity, removeAction: @escaping () -> Void, biometricsValueChanged: @escaping (Bool) -> Void) {
        self.removeAction = removeAction
        self.biometricsValueChanged = biometricsValueChanged
        super.init(frame: .zero)
        
        setupUI(with: identity)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOrContract)))
    }
            
    //MARK: - setup UI
    func setupUI(with identity: Identity) {
        
        backgroundColor = .disabledGrayBackground
        
        //body stackview
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let logoImage = UIImage(data: identity.identityProvider.logo) {
            imageView.image = logoImage
        }
        imageView.size(CGSize(width: 42, height: 42))
        
        let title = identity.displayName ?? ""
        let subtitle = identity.identityProvider.displayName ?? ""
        var attributedStringBody = NSMutableAttributedString()
        attributedStringBody.append(NSAttributedString(string: title, attributes: AttributedStringHelper.attributes(font: .sourceSansProBold(size: 16), color: .secondaryColor, lineSpacing: 6)))
        attributedStringBody.append(NSAttributedString(string: "\n"))
        attributedStringBody.append(NSAttributedString(string: subtitle, attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .secondaryColor, lineSpacing: 6)))
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
        
        // line 2
        let line2 = UIView()
        line2.height(1)
        line2.backgroundColor = .backgroundColor
        
        // Account
        let accountLabel = UILabel()
        accountLabel.attributedText = NSAttributedString(
            string: L.TwoFactorKeys.Label.Account.localization,
            attributes: AttributedStringHelper.attributes(
                font: .sourceSansProRegular(size: 14),
                color: .secondaryColor,
                lineSpacing: 6)
        )
        
        let accountValue = UILabel()
        accountValue.attributedText = NSAttributedString(
            string: identity.displayName,
            attributes: AttributedStringHelper.attributes(
                font: .sourceSansProSemiBold(size: 14),
                color: .secondaryColor,
                lineSpacing: 6)
        )

        
        let firstLoginStack = UIStackView(arrangedSubviews: [accountLabel, accountValue])
        firstLoginStack.axis = .horizontal
        firstLoginStack.distribution = .fillEqually
        
        // line 3
        let line3 = UIView()
        line3.height(1)
        line3.backgroundColor = .backgroundColor
        
        // Unique eduID
        let uniqueIdLabel = UILabel()
        uniqueIdLabel.attributedText = NSAttributedString(
            string: L.TwoFactorKeys.Label.UniqueKeyId.localization,
            attributes: AttributedStringHelper.attributes(
                font: .sourceSansProRegular(size: 14),
                color: .secondaryColor,
                lineSpacing: 6)
        )
        
        let uniqueIdValue = UILabel()
        uniqueIdValue.numberOfLines = 0
        uniqueIdValue.attributedText = NSAttributedString(
            string: identity.identifier,
            attributes: AttributedStringHelper.attributes(
                font: .sourceSansProSemiBold(size: 14),
                color: .secondaryColor,
                lineSpacing: 6)
        )
        
        let uniqueIdStack = UIStackView(arrangedSubviews: [uniqueIdLabel, uniqueIdValue])
        uniqueIdStack.axis = .horizontal
        uniqueIdStack.distribution = .fillEqually
        
        // line 4
        let line4 = UIView()
        line4.height(1)
        line4.backgroundColor = .backgroundColor
        
        // Biometrics
        let biometricsLabel = UILabel()
        biometricsLabel.attributedText = NSAttributedString(
            string: L.TwoFactorKeys.Label.UseBiometrics.localization,
            attributes: AttributedStringHelper.attributes(
                font: .sourceSansProRegular(size: 14),
                color: .secondaryColor,
                lineSpacing: 6)
        )
        
        let biometricsValue = UISwitch()
        biometricsValue.tintColor = .backgroundColor
        biometricsValue.addTarget(self, action: #selector(biometricsSwitchToggled), for: .valueChanged)
        biometricsValue.isOn = identity.biometricIDEnabled == NSNumber(true)
        biometricsValue.isEnabled = ServiceContainer.sharedInstance().secretService.biometricIDAvailable
        
        let biometricsStack = UIStackView(arrangedSubviews: [biometricsLabel, biometricsValue])
        uniqueIdStack.axis = .horizontal
        uniqueIdStack.distribution = .fillEqually
        
        // line 5
        let line5 = UIView()
        line5.height(1)
        line5.backgroundColor = .backgroundColor
        
        // remove button
        let button = EduIDButton(type: .borderedRed, buttonTitle: L.TwoFactorKeys.DeleteKey.localization)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [
            bodyStack,
            line2,
            firstLoginStack,
            line3,
            uniqueIdStack,
            line4,
            biometricsStack,
            line5,
            button
        ])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 18
        
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
    func buttonAction() {
        removeAction()
    }
    
    @objc
    func biometricsSwitchToggled(_ sender: UISwitch) {
        let newValue = sender.isOn
        self.biometricsValueChanged(newValue)
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
