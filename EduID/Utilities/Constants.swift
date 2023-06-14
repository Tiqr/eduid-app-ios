import UIKit

enum Constants {
    
    enum ButtonTitles {
        static let approve = "Approve"
        static let cancel = "Cancel"
        static let next = "Next"
        static let proceed = "Proceed"
        static let delete = "Delete"
    }
    
    enum AlertTiles {
        static let skipUsingBiometricsTitle = "Proceed without using biometric access?"
        
    }
    
    enum AlertMessages {
        static let skipUsingBiometricsMessage = "This permanently disables this feature"
    }
    
    enum RegEx {
        static let emailRegex = #"^(?=.{6,})[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        static let nameRegex = #"^[a-zA-Z]+(?:-[a-zA-Z]+)*$"#
        static let passwordRegex = #"(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]).{8,}"#
        static let phoneRegex = #"^(?:(?:00|\+)?\d{1,2}\s?)?\(?(?:\d{3}[\s-]?\d{3}[\s-]?\d{4}|\d{10})\)?$"#
    }
    
    enum InvalidInput {
        static let revise = ". Please revise your input"
        static let email = "Invalid email format\(revise)"
        static let name = "Invalid name format\(revise)"
        static let password = "A password must be 8 characters, contain an uppercase letter, and a special character."
        static let phone = "Invalid phone format\(revise)"
    }
    
    enum BiometricDefaults {
        static let key = "USER_HAS_SETUP_BIOMETRICS"
    }
    
    enum Enrolment {
        static let challenge = "EnrollmentChallenge"
    }
    
    enum KeyChain {
        static let keyPrefix = Bundle.main.bundleIdentifier ?? "nl.eduid"
        static let uuid = UUID()
    }
    
    enum Headers {
        static let authorization = "Authorization"
    }
    
    enum UserInfoKey {
        static let tiqrAuthObject = "tiqrAuthenticationObject"
        static let emailUpdateUrl = "emailUpdateUrl"
    }
    
}
