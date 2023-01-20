import UIKit
import TinyConstraints

class OnboardingSuccessViewController: EduIDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - PosterLabel
        let posterLabel = UILabel()
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Your eduID app\nis ready for use", attributes: [.font : UIFont.proximaNovaSoftSemiBold(size: 32), .foregroundColor: UIColor.charcoal])
        attributedText.setAttributeTo(part: "Your eduID app", attributes: [.font : UIFont.proximaNovaSoftSemiBold(size: 24), .foregroundColor: UIColor.primaryColor])
        posterLabel.attributedText = attributedText
        posterLabel.numberOfLines = 2
        posterLabel.textAlignment = .center
        view.addSubview(posterLabel)
        posterLabel.width(to: view)
        posterLabel.height(86)
        posterLabel.centerX(to: view)
        posterLabel.top(to: view, offset: 150)
        
        //MARK: - blue bottom view
        let blueBottomView = UIView()
        blueBottomView.translatesAutoresizingMaskIntoConstraints = false
        blueBottomView.backgroundColor = .backgroundColor
        view.addSubview(blueBottomView)
        blueBottomView.width(to: view)
        blueBottomView.bottom(to: view)
        blueBottomView.height(236)
        
        //MARK: - image
        let image = UIImageView(image: .readyForUse)
        view.addSubview(image)
        image.width(to: view)
        image.contentMode = .scaleAspectFit
        image.bottom(to: view, offset: -176)
        
    }

}
