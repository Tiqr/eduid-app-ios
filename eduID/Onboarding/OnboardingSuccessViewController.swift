import UIKit
import TinyConstraints

class OnboardingSuccessViewController: EduIDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - PosterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your eduID app\nis ready for use", size: 32, primary: "Your eduID app")
        view.addSubview(posterLabel)
        posterLabel.width(to: view)
        posterLabel.centerX(to: view)
        posterLabel.top(to: view, offset: 125)
        
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
        image.aspectRatio(0.761)
        image.contentMode = .scaleAspectFit
        image.bottom(to: view, offset: -76)
        
    }

}
