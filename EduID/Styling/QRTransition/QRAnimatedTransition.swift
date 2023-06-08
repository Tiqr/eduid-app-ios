import UIKit

class QRAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    static let frequency: TimeInterval = 0.025
    
    //checker size in pixels
    static let resolution: CGFloat = 12
    
    var timer: Timer?
    
    // progress is in range 1-100
    static func createCheckerPath(progress: Float) -> UIBezierPath {
        let path = UIBezierPath()
        
        let numberOfSquaresHorizontal = Int(UIScreen.main.bounds.width / resolution) + 1
        let numberOfSquaresVertical = Int(UIScreen.main.bounds.height / resolution) + 1
        
        for i in 0...numberOfSquaresVertical {
            for j in 0...numberOfSquaresHorizontal {
                if Float(arc4random_uniform(100)) < progress {
                    path.append(UIBezierPath(rect: CGRect(x: CGFloat(j) * resolution, y: CGFloat(i) * resolution, width: resolution, height: resolution)))
                }
            }
        }
        return path
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let mask = CAShapeLayer()
        mask.path = QRAnimatedTransition.createCheckerPath(progress: presenting ? 0 : 100).cgPath
        
        if presenting {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                containerView.addSubview(presentedView)
                presentedView.layer.mask = mask
                let startTransitionTime = Date()
                timer = Timer.scheduledTimer(withTimeInterval: QRAnimatedTransition.frequency, repeats: true, block: { [weak self] timer in
                    guard let self = self else { return }
                    
                    let progress = (Date().timeIntervalSince1970 - startTransitionTime.timeIntervalSince1970) / self.transitionDuration(using: transitionContext) * 100
                    mask.path = QRAnimatedTransition.createCheckerPath(progress: Float(progress)).cgPath
                })
            }
        } else {
            if let viewToDismiss = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                viewToDismiss.layer.mask = mask
                let startTransitionTime = Date()
                timer = Timer.scheduledTimer(withTimeInterval: QRAnimatedTransition.frequency, repeats: true, block: { [weak self] timer in
                    guard let self = self else { return }
                    
                    let progress = 100 - (Date().timeIntervalSince1970 - startTransitionTime.timeIntervalSince1970) / self.transitionDuration(using: transitionContext) * 100
                    mask.path = QRAnimatedTransition.createCheckerPath(progress: Float(progress)).cgPath
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration(using: transitionContext), execute: { [weak self] in
            
            self?.timer?.invalidate()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
