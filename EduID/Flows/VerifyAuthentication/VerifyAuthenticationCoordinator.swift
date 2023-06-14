import UIKit
import TiqrCoreObjC

protocol VerifyAuthenticationDelegate: AnyObject {
    func verifyAuthenticationCoordinatorDismissActivityFlow(coordinator: CoordinatorType)
}

class VerifyAuthenticationCoordinator: CoordinatorType {
    
    var viewControllerToPresentOn: UIViewController?
    weak var delegate: VerifyAuthenticationDelegate?
    private var payload: String?
    var challenge: NSObject?
    var challengeType: TIQRChallengeType?
    private var dismissVerifyAuthentication: (() -> Void)?
    
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    func start(with payload: String) {
        self.payload = payload
        authenticate()
    }
    
    private func authenticate() {
        guard let payload = self.payload else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            ServiceContainer.sharedInstance().challengeService.startChallenge(fromScanResult: payload) {
                [weak self] type, challengeObject, error in
                guard let self = self else { return }
                switch type {
                case .enrollment, .authentication:
                    let viewModel = ScanViewModel()
                    viewModel.challenge = challengeObject
                    viewModel.challengeType = type
                    self.handleAuthenticationResult(with: viewModel)
                case .invalid:
                    break
                default:
                    break
                }
            }
        })
    }
    
    private func handleAuthenticationResult(with viewModel: ScanViewModel) {
        let viewController = VerifyScanResultViewController(viewModel: viewModel) { [weak self] in
            guard let self else { return }
            self.delegate?.verifyAuthenticationCoordinatorDismissActivityFlow(coordinator: self)
        }
        viewControllerToPresentOn?.present(viewController, animated: true)
    }
}
