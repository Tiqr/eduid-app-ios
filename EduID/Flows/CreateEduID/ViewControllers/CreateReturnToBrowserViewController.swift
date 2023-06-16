import UIKit
import TinyConstraints

class CreateReturnToBrowserViewController: CreateEduIDBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .returnToBrowser
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel.posterTextLabel(text: L.WelcomeToApp.ReturnBrowserTitle.localization, size: 24)
        let explanationLabel = UILabel.plainTextLabelPartlyBold(text: L.WelcomeToApp.ReturnBrowserText.localization)
        let image = UIImageView(image: .returnToBrowser)
        image.contentMode = .scaleAspectFit
        image.width(view.frame.height / 2)
        image.height(view.frame.height / 2)
        
        let dismissButton = EduIDButton(type: .primary, buttonTitle: L.WelcomeToApp.GotItButton.localization)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        let spacer = UIView()
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, explanationLabel, image, spacer, dismissButton])
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.distribution = .fill
        mainStack.alignment = .center
        mainStack.spacing = 20
        view.addSubview(mainStack)
        
        mainStack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        titleLabel.height(34)
        dismissButton.width(to: mainStack, offset: -24)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
}
