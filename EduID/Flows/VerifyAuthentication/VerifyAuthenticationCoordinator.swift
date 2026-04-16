import UIKit
import TiqrCoreObjC
import Tiqr

protocol VerifyAuthenticationDelegate: AnyObject {
    func verifyAuthenticationCoordinatorDismissActivityFlow(coordinator: CoordinatorType)
}

class VerifyAuthenticationCoordinator: CoordinatorType {
    
    var viewControllerToPresentOn: UIViewController?
    weak var delegate: VerifyAuthenticationDelegate?
    private var payload: String?
    private var serviceName: String?
    var challengeType: TIQRChallengeType?
    private var dismissVerifyAuthentication: (() -> Void)?
    
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    func start(payload: String, serviceName: String?) {
        self.payload = payload
        self.serviceName = serviceName
        authenticate()
        // Next to that, we also clear the recent notifications cache, making sure this screen is not triggered twice
        // (by getting it, we also clear it)
        let appGroup = Bundle.main.object(forInfoDictionaryKey: "TiqrAppGroup") as! String
        _ = RecentNotifications(appGroup: appGroup).getLastNotificationData()
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
                    viewModel.serviceName = serviceName
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
        (viewControllerToPresentOn as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
}
