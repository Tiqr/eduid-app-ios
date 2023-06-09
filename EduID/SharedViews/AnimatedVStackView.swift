import UIKit

class AnimatedVStackView: BasicStackView {
    
    func hideAndTriggerAll(onlyThese indices: [Int]) {
        var filterSubViews: [UIView] = []
        for index in indices {
            filterSubViews.append(arrangedSubviews[index])
        }
        filterSubViews.forEach { view in
            view.alpha = 0.75
            view.transform = CGAffineTransformMakeTranslation(4, 0)
        }
    }
    
    func animate(onlyThese indices: [Int]) {
        var filterSubViews: [UIView] = []
        for index in indices {
            filterSubViews.append(arrangedSubviews[index])
        }
        filterSubViews.enumerated().forEach { (index, view) in
            UIView.animate(withDuration: 1, delay: Double(index) / 16, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3) {
                view.transform = .identity
            }
        }
        arrangedSubviews.forEach { view in
            UIView.animate(withDuration: 0.3) {
                view.alpha = 1
            }
        }
    }
}

class AnimatedHStackView: UIStackView {
    
    func hideAndTriggerAll() {
        arrangedSubviews.forEach { view in
            view.alpha = 0.75
            view.transform = CGAffineTransformMakeTranslation(0, 4)
        }
    }
    
    func animate() {
        arrangedSubviews.enumerated().forEach { (index, view) in
            UIView.animate(withDuration: 1, delay: Double(index) / 16, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3) {
                view.transform = .identity
            }
            
            UIView.animate(withDuration: 0.3) {
                view.alpha = 1
            }
        }
    }
}
