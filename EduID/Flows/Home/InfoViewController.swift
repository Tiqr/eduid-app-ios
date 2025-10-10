//
//  InfoViewController.swift
//  eduID
//
//  Created by Dániel Zolnai on 01/02/2024.
//
import Foundation
import UIKit
import TinyConstraints
import TiqrCoreObjC

class InfoViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    private func setup() {
        if #available(iOS 15.0, *) {
            self.modalPresentationStyle = .pageSheet
        } else {
            self.modalPresentationStyle = .overCurrentContext
            self.modalTransitionStyle = .crossDissolve
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            view.backgroundColor = .clear
        } else {
            view.backgroundColor = .black.withAlphaComponent(0.2)
        }
        let insetView = UIView()
        insetView.backgroundColor = .white
        view.addSubview(insetView)
        if #available(iOS 15.0, *) {
            insetView.bottomToSuperview()
            insetView.widthToSuperview()
        } else {
            insetView.centerYToSuperview()
            insetView.horizontalToSuperview(insets: .horizontal(20))
        }
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "eduID"
        let appVersionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let appVersionCode = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "0"
#if DEBUG
        let debugString = "DEBUG"
#else
        let debugString = ""
#endif
        let tiqrReleaseVersion = TiqrConfig.shortGitReleaseVersion
        let tiqrLibraryVersion = TiqrConfig.shortCoreLibraryVersion
        let versionText = "\(appName) • v\(appVersionName) (\(appVersionCode)) • \(tiqrReleaseVersion ?? "<unknown>") - core \(tiqrLibraryVersion ?? "<unknown>") \(debugString)"
        let eduidVersion = UILabel.plainTextLabelPartlyBold(text: versionText)
        eduidVersion.textAlignment = .center
        let eduidLogo = UIImageView()
        eduidLogo.translatesAutoresizingMaskIntoConstraints = false
        eduidLogo.image = .eduIDLogo
        eduidLogo.contentMode = .scaleAspectFit
        let providedBy = UILabel.plainTextLabelPartlyBold(text: L.Security.ProvidedBy.localization)
        providedBy.textAlignment = .center
        let surfLogo = UIImageView()
        surfLogo.translatesAutoresizingMaskIntoConstraints = false
        surfLogo.image = .surfLogo.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        surfLogo.contentMode = .scaleAspectFit
        surfLogo.tintColor = .black
        let closeButton = EduIDButton(type: .primary, buttonTitle: L.Generic.RequestError.CloseButton.localization)
        let stack = UIStackView(arrangedSubviews: [eduidVersion, eduidLogo, providedBy, surfLogo, closeButton])
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 16
        insetView.addSubview(stack)
        stack.edgesToSuperview(insets: .uniform(20), usingSafeArea: true)
        
        eduidVersion.widthToSuperview()
        eduidLogo.widthToSuperview()
        eduidLogo.height(32.0)
        eduidLogo.centerXToSuperview()
        providedBy.widthToSuperview()
        surfLogo.widthToSuperview()
        surfLogo.height(40.0)
        surfLogo.centerXToSuperview()
        closeButton.widthToSuperview()
        closeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func dismissPopup() {
        self.dismiss(animated: true)
    }
}
