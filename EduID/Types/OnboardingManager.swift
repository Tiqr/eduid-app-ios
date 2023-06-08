import Foundation
import TiqrCoreObjC

public class OnboardingManager: NSObject {
    
    //MARK: - singleton instance
    public static var shared = OnboardingManager()
    private let defaults = UserDefaults.standard
    static var userdefaultsFlowTypeKey = "userdefaultsFlowTypeKey"
    
    //MARK: - private init()
    private override init() {
        super.init()
    }
    
    //MARK: - query
    public func getAppropriateLaunchOption() -> OnboardingFlowType {
        testCreateAUser()
        if let onboardingFlowTypeString = defaults.value(forKey: OnboardingManager.userdefaultsFlowTypeKey) as? String, let onboardingFlowType = OnboardingFlowType(rawValue: onboardingFlowTypeString) {
            return onboardingFlowType
        } else {
            if ServiceContainer.sharedInstance().identityService.identityCount() > 0 {
                return setAndProvideCorrectFlow(ServiceContainer.sharedInstance().secretService.biometricIDAvailable ? .existingUserWithSecret : .existingUserWithoutSecret)
            } else {
                return .newUser
            }
        }
    }
    
    private func setAndProvideCorrectFlow(_ flow: OnboardingFlowType) -> OnboardingFlowType {
        switch flow {
        case .existingUserWithSecret:
            defaults.set(OnboardingFlowType.existingUserWithSecret.rawValue, forKey: OnboardingManager.userdefaultsFlowTypeKey)
            return .existingUserWithSecret
            
        case .existingUserWithoutSecret:
            defaults.set(OnboardingFlowType.existingUserWithoutSecret.rawValue, forKey: OnboardingManager.userdefaultsFlowTypeKey)
            return .existingUserWithoutSecret
            
        default: return .newUser
        }
    }
    
    func testCreateAUser() {
    }
}

public enum OnboardingFlowType: String {
    case newUser
    case existingUserWithSecret
    case existingUserWithoutSecret
    case mfaOnly
    case onboard
}


