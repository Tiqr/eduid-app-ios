import UIKit
import TinyConstraints

class ActivityItemControl: UIControl {

    init(imagePath: String? = nil, image: UIImage? = nil, title: String, date: Date) {
        super.init(frame: .zero)
        
        // - the icon image
        let imageParent = UIView()
        imageParent.size(CGSize(width: 82, height: 82))
        let imageView = UIImageView(image: image)
        imageView.size(CGSize(width: 50, height: 50))
        imageView.tintColor = .charcoalColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageParent.addSubview(imageView)
        imageView.center(in: imageParent)
        
        // - the middle part with title and date
        let middleParent = UIView()
        let titleLabel = UILabel()
        titleLabel.font = R.font.sourceSansProBold(size: 16)
        titleLabel.textColor = .charcoalColor
        titleLabel.text = title
        let dateLabel = UILabel()
        dateLabel.font = R.font.sourceSansProRegular(size: 16)
        dateLabel.textColor = .disabledGray
        dateLabel.text = ActivityItemControl.dateFormatter.string(from: date)
        let middleStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        middleStack.axis = .vertical
        middleStack.distribution = .fillEqually
        middleStack.spacing = 0
        middleStack.translatesAutoresizingMaskIntoConstraints = false
        middleParent.addSubview(middleStack)
        middleStack.edges(to: middleParent, insets: TinyEdgeInsets(top: 14, left: 6, bottom: 14, right: 6))
        
        // - the chevron image
        let chevronParent = UIView()
        chevronParent.size(CGSize(width: 82, height: 82))
        let chevronView = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevronView.tintColor = .charcoalColor
        chevronView.contentMode = .scaleAspectFit
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        chevronView.size(CGSize(width: 22, height: 22))
        chevronParent.addSubview(chevronView)
        chevronView.center(in: chevronParent)
        
        // - the master stack
        let stack = UIStackView(arrangedSubviews: [imageParent, middleParent, chevronParent])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.edges(to: self)
        
        backgroundColor = .disabledGrayBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy - HH:mm"
        return formatter
    }
}
