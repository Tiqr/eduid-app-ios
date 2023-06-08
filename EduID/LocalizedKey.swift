import Foundation

struct LocalizedKey {
    struct Sidebar {
        static let home = "sidebar-home"
        static let personalInfo = "sidebar-personalInfo"
        static let dataActivity = "sidebar-dataActivity"
        static let security = "sidebar-security"
        static let account = "sidebar-account"
    }
    struct Start {
        static let hi = "start-hi"
        static let manage = "start-manage"
    }
    struct Header {
        static let title = "header-title"
        static let logout = "header-logout"
    }
    struct Landing {
        static let logoutTitle = "landing-logoutTitle"
        static let logoutStatus = "landing-logoutStatus"
        static let loginAgain = "landing-loginAgain"
        static let deleteTitle = "landing-deleteTitle"
        static let deleteStatus = "landing-deleteStatus"
        static let registerAgain = "landing-registerAgain"
    }
    struct NotFound {
        static let title = "notFound-title"
        static let title2 = "notFound-title2"
    }
    struct Profile {
        static let title = "profile-title"
        static let info = "profile-info"
        static let basic = "profile-basic"
        static let email = "profile-email"
        static let name = "profile-name"
        static let validated = "profile-validated"
        static let firstAndLastName = "profile-firstAndLastName"
        static let firstAndLastNameInfo = "profile-firstAndLastNameInfo"
        static let verify = "profile-verify"
        static let student = "profile-student"
        static let studentInfo = "profile-studentInfo"
        static let prove = "profile-prove"
        static let me = "profile-me"
        static let providedBy = "profile-provided-by"
        static let removeServiceTitle = "profile-prompt-remove-service-title"
        static let removeServicePrompt = "profile-prompt-remove-service"
        static let trusted = "profile-trusted"
        static let trustedInfo = "profile-trustedInfo"
        static let link = "profile-link"
        static let institution = "profile-institution"
        static let affiliations = "profile-affiliations"
        static let expires = "profile-expires"
        static let addRoleInstitution = "profile-add-role-institution"
        static let infoText = "profile-info-text"
        static let expiresValue = "profile-expiresValue"
        static let verifiedAt = "profile-verifiedAt"
        static let proceed = "profile-proceed"
    }
    struct VerifyFirstAndLastName {
        static let addInstitution = "verifyFirstAndLastName-addInstitution"
        static let addInstitutionConfirmation = "verifyFirstAndLastName-addInstitutionConfirmation"
    }
    struct VerifyStudent {
        static let addInstitution = "verifyStudent-addInstitution"
        static let addInstitutionConfirmation = "verifyStudent-addInstitutionConfirmation"
    }
    struct VerifyParty {
        static let addInstitution = "verifyParty-addInstitution"
        static let addInstitutionConfirmation = "verifyParty-addInstitutionConfirmation"
    }
    struct EppnAlreadyLinked {
        static let header = "eppnAlreadyLinked-header"
        static let info = "eppnAlreadyLinked-info"
        static let proceed = "eppnAlreadyLinked-proceed"
        static let proceedLink = "eppnAlreadyLinked-proceedLink"
        static let retryLink = "eppnAlreadyLinked-retryLink"
    }
    struct Edit {
        static let title = "edit-title"
        static let info = "edit-info"
        static let givenName = "edit-givenName"
        static let familyName = "edit-familyName"
        static let update = "edit-update"
        static let cancel = "edit-cancel"
        static let updated = "edit-updated"
        static let back = "edit-back"
    }
    struct Email {
        static let title = "email-title"
        static let info = "email-info"
        static let email = "email-email"
        static let update = "email-update"
        static let cancel = "email-cancel"
        static let updated = "email-updated"
        static let confirmed = "email-confirmed"
        static let back = "email-back"
        static let emailEquality = "email-emailEquality"
        static let duplicateEmail = "email-duplicateEmail"
        static let outstandingPasswordForgotten = "email-outstandingPasswordForgotten"
        static let outstandingPasswordForgottenConfirmation = "email-outstandingPasswordForgottenConfirmation"
    }
    struct Security {
        static let title = "security-title"
        static let subTitle = "security-subTitle"
        static let secondSubTitle = "security-secondSubTitle"
        static let usePassword = "security-usePassword"
        static let usePublicKey = "security-usePublicKey"
        static let notSet = "security-notSet"
        static let notSupported = "security-notSupported"
        static let useMagicLink = "security-useMagicLink"
        static let rememberMe = "security-rememberMe"
        static let securityKey = "security-securityKey"
        static let test = "security-test"
        static let addSecurityKey = "security-addSecurityKey"
        static let addSecurityKeyInfo = "security-addSecurityKeyInfo"
        static let settings = "security-settings"
        static let rememberMeInfo = "security-rememberMeInfo"
        static let noRememberMeInfo = "security-noRememberMeInfo"
        static let forgetMe = "security-forgetMe"
    }
    struct Tiqr {
        static let title = "tiqr-title"
        static let info = "tiqr-info"
        static let fetch = "tiqr-fetch"
        static let deactivate = "tiqr-deactivate"
        static let backupCodes = "tiqr-backupCodes"
        static let app = "tiqr-app"
        static let phoneId = "tiqr-phoneId"
        static let APNS = "tiqr-APNS"
        static let APNS_DIRECT = "tiqr-APNS_DIRECT"
        static let FCM = "tiqr-FCM"
        static let GCM = "tiqr-GCM"
        static let FCM_DIRECT = "tiqr-FCM_DIRECT"
        static let appCode = "tiqr-appCode"
        static let lastLogin = "tiqr-lastLogin"
        static let activated = "tiqr-activated"
        static let dateTimeOn = "tiqr-dateTimeOn"
        static let backupMethod = "tiqr-backupMethod"
        static let sms = "tiqr-sms"
        static let code = "tiqr-code"
    }
    struct Home {
        static let home = "home-home"
        static let welcome = "home-welcome"
        static let dataActivity = "home-data-activity"
        static let personal = "home-personal"
        static let security = "home-security"
        static let account = "home-account"
        static let institutions = "home-institutions"
        static let services = "home-services"
        static let favorites = "home-favorites"
        static let settings = "home-settings"
    }
    struct Links {
        static let teams = "links-teams"
        static let teamsHref = "links-teamsHref"
    }
    struct Account {
        static let title = "account-title"
        static let titleDelete = "account-titleDelete"
        static let info = "account-info"
        static let created = "account-created"
        static let delete = "account-delete"
        static let cancel = "account-cancel"
        static let deleteInfo = "account-deleteInfo"
        static let data = "account-data"
        static let personalInfo = "account-personalInfo"
        static let downloadData = "account-downloadData"
        static let downloadDataConfirmation = "account-downloadDataConfirmation"
        static let deleteTitle = "account-deleteTitle"
        static let info1 = "account-info1"
        static let info2 = "account-info2"
        static let info3 = "account-info3"
        static let info4 = "account-info4"
        static let deleteAccount = "account-deleteAccount"
        static let deleteAccountConfirmation = "account-deleteAccountConfirmation"
        static let deleteAccountSure = "account-deleteAccountSure"
        static let deleteAccountWarning = "account-deleteAccountWarning"
        static let proceed = "account-proceed"
        static let name = "account-name"
        static let namePlaceholder = "account-namePlaceholder"
    }
    struct DataActivity {
        static let title = "dataActivity-title"
        static let info = "dataActivity-info"
        static let explanation = "dataActivity-explanation"
        static let noServices = "dataActivity-noServices"
        static let name = "dataActivity-name"
        static let add = "dataActivity-add"
        static let access = "dataActivity-access"
    }
    struct Details {
        static let login = "details-login"
        static let delete = "details-delete"
        static let first = "details-first"
        static let eduID = "details-eduID"
        static let homePage = "details-homePage"
        static let deleteDisclaimer = "details-deleteDisclaimer"
        static let access = "details-access"
        static let details = "details-details"
        static let consent = "details-consent"
        static let expires = "details-expires"
        static let revoke = "details-revoke"
        static let deleteService = "details-deleteService"
        static let deleteServiceConfirmation = "details-deleteServiceConfirmation"
        static let deleteTokenConfirmation = "details-deleteTokenConfirmation"
        static let deleteToken = "details-deleteToken"
        static let deleted = "details-deleted"
        static let tokenDeleted = "details-tokenDeleted"
    }
    struct Institution {
        static let title = "institution-title"
        static let info = "institution-info"
        static let name = "institution-name"
        static let eppn = "institution-eppn"
        static let displayName = "institution-displayName"
        static let affiliations = "institution-affiliations"
        static let expires = "institution-expires"
        static let expiresValue = "institution-expiresValue"
        static let delete = "institution-delete"
        static let cancel = "institution-cancel"
        static let deleted = "institution-deleted"
        static let back = "institution-back"
        static let deleteInstitution = "institution-deleteInstitution"
        static let deleteInstitutionConfirmation = "institution-deleteInstitutionConfirmation"
    }
    struct Credential {
        static let title = "credential-title"
        static let info = "credential-info"
        static let name = "credential-name"
        static let cancel = "credential-cancel"
        static let update = "credential-update"
        static let deleted = "credential-deleted"
        static let updated = "credential-updated"
        static let back = "credential-back"
        static let deleteCredential = "credential-deleteCredential"
        static let deleteCredentialConfirmation = "credential-deleteCredentialConfirmation"
    }
    struct Password {
        static let addTitle = "password-addTitle"
        static let updateTitle = "password-updateTitle"
        static let addInfo = "password-addInfo"
        static let updateInfo = "password-updateInfo"
        static let resetTitle = "password-resetTitle"
        static let newPassword = "password-newPassword"
        static let confirmPassword = "password-confirmPassword"
        static let setUpdate = "password-setUpdate"
        static let updateUpdate = "password-updateUpdate"
        static let cancel = "password-cancel"
        static let set = "password-set"
        static let reset = "password-reset"
        static let updated = "password-updated"
        static let deleted = "password-deleted"
        static let deletePassword = "password-deletePassword"
        static let deletePasswordConfirmation = "password-deletePasswordConfirmation"
        static let back = "password-back"
        static let passwordDisclaimer = "password-passwordDisclaimer"
        static let invalidCurrentPassword = "password-invalidCurrentPassword"
        static let passwordResetHashExpired = "password-passwordResetHashExpired"
        static let forgotPassword = "password-forgotPassword"
        static let passwordResetSendAgain = "password-passwordResetSendAgain"
        static let forgotPasswordConfirmation = "password-forgotPasswordConfirmation"
        static let outstandingEmailReset = "password-outstandingEmailReset"
        static let outstandingEmailResetConfirmation = "password-outstandingEmailResetConfirmation"
    }
    struct Flash {
        static let passwordLink = "flash-passwordLink"
    }
    struct Webauthn {
        static let setTitle = "webauthn-setTitle"
        static let updateTitle = "webauthn-updateTitle"
        static let publicKeys = "webauthn-publicKeys"
        static let noPublicKeys = "webauthn-noPublicKeys"
        static let nameRequired = "webauthn-nameRequired"
        static let revoke = "webauthn-revoke"
        static let addDevice = "webauthn-addDevice"
        static let info = "webauthn-info"
        static let back = "webauthn-back"
        static let setUpdate = "webauthn-setUpdate"
        static let updateUpdate = "webauthn-updateUpdate"
        static let credentialName = "webauthn-credentialName"
        static let credentialNamePlaceholder = "webauthn-credentialNamePlaceholder"
        static let test = "webauthn-test"
        static let testInfo = "webauthn-testInfo"
        static let testFlash = "webauthn-testFlash"
    }
    struct RememberMe {
        static let yes = "rememberMe-yes"
        static let no = "rememberMe-no"
        static let header = "rememberMe-header"
        static let info = "rememberMe-info"
    }
    struct Footer {
        static let privacy = "footer-privacy"
        static let terms = "footer-terms"
        static let help = "footer-help"
        static let poweredBy = "footer-poweredBy"
    }
    struct Modal {
        static let cancel = "modal-cancel"
        static let confirm = "modal-confirm"
    }
    struct Format {
        static let creationDate = "format-creationDate"
    }
    struct GetApp {
        static let header = "getApp-header"
        static let info = "getApp-info"
        static let google = "getApp-google"
        static let apple = "getApp-apple"
        static let after = "getApp-after"
        static let back = "getApp-back"
        static let next = "getApp-next"
    }
    struct Sms {
        static let header = "sms-header"
        static let info = "sms-info"
        static let codeIncorrect = "sms-codeIncorrect"
        static let sendSMSAgain = "sms-sendSMSAgain"
        static let maxAttemptsPre = "sms-maxAttemptsPre"
        static let maxAttemptsPost = "sms-maxAttemptsPost"
        static let here = "sms-here"
    }
    struct EnrollApp {
        static let header = "enrollApp-header"
    }
    struct Recovery {
        static let header = "recovery-header"
        static let info = "recovery-info"
        static let methods = "recovery-methods"
        static let phoneNumber = "recovery-phoneNumber"
        static let phoneNumberInfo = "recovery-phoneNumberInfo"
        static let backupCode = "recovery-backupCode"
        static let backupCodeInfo = "recovery-backupCodeInfo"
        static let save = "recovery-save"
        static let active = "recovery-active"
        static let copy = "recovery-copy"
        static let copied = "recovery-copied"
        static let cont = "recovery-continue"
        static let leaveConfirmation = "recovery-leaveConfirmation"
    }
    struct PhoneVerification {
        static let header = "phoneVerification-header"
        static let info = "phoneVerification-info"
        static let text = "phoneVerification-text"
        static let verify = "phoneVerification-verify"
        static let placeHolder = "phoneVerification-placeHolder"
        static let phoneIncorrect = "phoneVerification-phoneIncorrect"
    }
    struct Congrats {
        static let header = "congrats-header"
        static let info = "congrats-info"
        static let next = "congrats-next"
    }
    struct Deactivate {
        static let titleDelete = "deactivate-titleDelete"
        static let info = "deactivate-info"
        static let recoveryCode = "deactivate-recoveryCode"
        static let recoveryCodeInfo = "deactivate-recoveryCodeInfo"
        static let verificationCode = "deactivate-verificationCode"
        static let codeIncorrect = "deactivate-codeIncorrect"
        static let next = "deactivate-next"
        static let deactivateApp = "deactivate-deactivateApp"
        static let sendSms = "deactivate-sendSms"
        static let maxAttempts = "deactivate-maxAttempts"
    }
    struct BackupCodes {
        static let title = "backupCodes-title"
        static let info = "backupCodes-info"
        static let phoneNumber = "backupCodes-phoneNumber"
        static let startTiqrAuthentication = "backupCodes-startTiqrAuthentication"
        static let code = "backupCodes-code"
    }
    struct UseApp {
        static let header = "useApp-header"
        static let info = "useApp-info"
        static let scan = "useApp-scan"
        static let noNotification = "useApp-noNotification"
        static let qrCodeLink = "useApp-qrCodeLink"
        static let qrCodePostfix = "useApp-qrCodePostfix"
        static let offline = "useApp-offline"
        static let offlineLink = "useApp-offlineLink"
        static let openEduIDApp = "useApp-openEduIDApp"
        static let lost = "useApp-lost"
        static let lostLink = "useApp-lostLink"
        static let timeOut = "useApp-timeOut"
        static let timeOutInfoFirst = "useApp-timeOutInfoFirst"
        static let timeOutInfoLast = "useApp-timeOutInfoLast"
        static let timeOutInfoLink = "useApp-timeOutInfoLink"
        static let responseIncorrect = "useApp-responseIncorrect"
        static let suspendedResult = "useApp-suspendedResult"
        static let accountNotSuspended = "useApp-accountNotSuspended"
        static let accountSuspended = "useApp-accountSuspended"
        static let minutes = "useApp-minutes"
        static let minute = "useApp-minute"
    }
    struct CreateFromInstitution {
        static let title = "createFromInstitution-title"
        static let header = "createFromInstitution-header"
        static let alreadyHaveAnEduID = "createFromInstitution-alreadyHaveAnEduID"
        static let info = "createFromInstitution-info"
        static let startFlow = "createFromInstitution-startFlow"
        static let welcome = "createFromInstitution-welcome"
        static let welcomeExisting = "createFromInstitution-welcomeExisting"
    }
    struct LinkFromInstitution {
        static let header = "linkFromInstitution-header"
        static let info = "linkFromInstitution-info"
        static let email = "linkFromInstitution-email"
        static let emailPlaceholder = "linkFromInstitution-emailPlaceholder"
        static let emailForbidden = "linkFromInstitution-emailForbidden"
        static let emailInUse1 = "linkFromInstitution-emailInUse1"
        static let emailInUse2 = "linkFromInstitution-emailInUse2"
        static let emailInUse3 = "linkFromInstitution-emailInUse3"
        static let invalidEmail = "linkFromInstitution-invalidEmail"
        static let institutionDomainNameWarning = "linkFromInstitution-institutionDomainNameWarning"
        static let institutionDomainNameWarning2 = "linkFromInstitution-institutionDomainNameWarning2"
        static let allowedDomainNamesError = "linkFromInstitution-allowedDomainNamesError"
        static let allowedDomainNamesError2 = "linkFromInstitution-allowedDomainNamesError2"
        static let agreeWithTerms = "linkFromInstitution-agreeWithTerms"
        static let requestEduIdButton = "linkFromInstitution-requestEduIdButton"
    }
    struct PollFromInstitution {
        static let header = "pollFromInstitution-header"
        static let info = "pollFromInstitution-info"
        static let awaiting = "pollFromInstitution-awaiting"
        static let openGMail = "pollFromInstitution-openGMail"
        static let openOutlook = "pollFromInstitution-openOutlook"
        static let spam = "pollFromInstitution-spam"
        static let loggedIn = "pollFromInstitution-loggedIn"
        static let loggedInInfo = "pollFromInstitution-loggedInInfo"
        static let timeOutReached = "pollFromInstitution-timeOutReached"
        static let timeOutReachedInfo = "pollFromInstitution-timeOutReachedInfo"
        static let resend = "pollFromInstitution-resend"
        static let resendLink = "pollFromInstitution-resendLink"
        static let mailResend = "pollFromInstitution-mailResend"
    }
    struct Login {
        static let requestEduId = "login-requestEduId"
        static let requestEduId2 = "login-requestEduId2"
        static let loginEduId = "login-loginEduId"
        static let whatis = "login-whatis"
        static let header = "login-header"
        static let headerSubTitle = "login-headerSubTitle"
        static let header2 = "login-header2"
        static let trust = "login-trust"
        static let loginOptions = "login-loginOptions"
        static let loginOptionsToolTip = "login-loginOptionsToolTip"
        static let email = "login-email"
        static let emailPlaceholder = "login-emailPlaceholder"
        static let passwordPlaceholder = "login-passwordPlaceholder"
        static let familyName = "login-familyName"
        static let givenName = "login-givenName"
        static let familyNamePlaceholder = "login-familyNamePlaceholder"
        static let givenNamePlaceholder = "login-givenNamePlaceholder"
        static let sendMagicLink = "login-sendMagicLink"
        static let loginWebAuthn = "login-loginWebAuthn"
        static let usePassword = "login-usePassword"
        static let usePasswordNoWebAuthn = "login-usePasswordNoWebAuthn"
        static let useMagicLink = "login-useMagicLink"
        static let useMagicLinkNoWebAuthn = "login-useMagicLinkNoWebAuthn"
        static let useWebAuth = "login-useWebAuth"
        static let useOr = "login-useOr"
        static let requestEduIdButton = "login-requestEduIdButton"
        static let rememberMe = "login-rememberMe"
        static let password = "login-password"
        static let passwordForgotten = "login-passwordForgotten"
        static let passwordForgottenLink = "login-passwordForgottenLink"
        static let login = "login-login"
        static let create = "login-create"
        static let newTo = "login-newTo"
        static let createAccount = "login-createAccount"
        static let useExistingAccount = "login-useExistingAccount"
        static let invalidEmail = "login-invalidEmail"
        static let requiredAttribute = "login-requiredAttribute"
        static let emailInUse1 = "login-emailInUse1"
        static let emailInUse2 = "login-emailInUse2"
        static let emailInUse3 = "login-emailInUse3"
        static let emailForbidden = "login-emailForbidden"
        static let emailNotFound1 = "login-emailNotFound1"
        static let emailNotFound2 = "login-emailNotFound2"
        static let emailNotFound3 = "login-emailNotFound3"
        static let emailOrPasswordIncorrect = "login-emailOrPasswordIncorrect"
        static let institutionDomainNameWarning = "login-institutionDomainNameWarning"
        static let institutionDomainNameWarning2 = "login-institutionDomainNameWarning2"
        static let allowedDomainNamesError = "login-allowedDomainNamesError"
        static let allowedDomainNamesError2 = "login-allowedDomainNamesError2"
        static let passwordDisclaimer = "login-passwordDisclaimer"
        static let alreadyGuestAccount = "login-alreadyGuestAccount"
        static let usePasswordLink = "login-usePasswordLink"
        static let useWebAuthnLink = "login-useWebAuthnLink"
        static let agreeWithTerms = "login-agreeWithTerms"
        static let next = "login-next"
        static let useOtherAccount = "login-useOtherAccount"
        static let noAppAccess = "login-noAppAccess"
        static let noMailAccess = "login-noMailAccess"
        static let forgotPassword = "login-forgotPassword"
        static let useAnother = "login-useAnother"
        static let optionsLink = "login-optionsLink"
    }
    struct Options {
        static let header = "options-header"
        static let noLogin = "options-noLogin"
        static let learn = "options-learn"
        static let learnLink = "options-learnLink"
        static let useApp = "options-useApp"
        static let useWebAuthn = "options-useWebAuthn"
        static let useLink = "options-useLink"
        static let usePassword = "options-usePassword"
    }
    struct MagicLink {
        static let header = "magicLink-header"
        static let info = "magicLink-info"
        static let awaiting = "magicLink-awaiting"
        static let openGMail = "magicLink-openGMail"
        static let openOutlook = "magicLink-openOutlook"
        static let spam = "magicLink-spam"
        static let loggedIn = "magicLink-loggedIn"
        static let loggedInInfo = "magicLink-loggedInInfo"
        static let timeOutReached = "magicLink-timeOutReached"
        static let timeOutReachedInfo = "magicLink-timeOutReachedInfo"
        static let resend = "magicLink-resend"
        static let resendLink = "magicLink-resendLink"
        static let mailResend = "magicLink-mailResend"
        static let loggedInDifferentDevice = "magicLink-loggedInDifferentDevice"
        static let loggedInDifferentDeviceInInfo = "magicLink-loggedInDifferentDeviceInInfo"
        static let loggedInDifferentDeviceInInfo2 = "magicLink-loggedInDifferentDeviceInInfo2"
        static let verificationCodeError = "magicLink-verificationCodeError"
        static let verify = "magicLink-verify"
    }
    struct Confirm {
        static let header = "confirm-header"
        static let thanks = "confirm-thanks"
    }
    struct ConfirmStepup {
        static let header = "confirmStepup-header"
        static let proceed = "confirmStepup-proceed"
        static let conditionMet = "confirmStepup-conditionMet"
    }
    struct Stepup {
        static let header = "stepup-header"
        static let info = "stepup-info"
        static let link = "stepup-link"
        static let linkExternalValidation = "stepup-linkExternalValidation"
    }
    struct Success {
        static let title = "success-title"
        static let info = "success-info"
    }
    struct Expired {
        static let title = "expired-title"
        static let info = "expired-info"
        static let back = "expired-back"
    }
    struct MaxAttempt {
        static let title = "maxAttempt-title"
        static let info = "maxAttempt-info"
    }
    struct WebAuthn {
        static let info = "webAuthn-info"
        static let browserPrompt = "webAuthn-browserPrompt"
        static let start = "webAuthn-start"
        static let header = "webAuthn-header"
        static let explanation = "webAuthn-explanation"
        static let next = "webAuthn-next"
        static let error = "webAuthn-error"
    }
    struct UseLink {
        static let header = "useLink-header"
        static let next = "useLink-next"
    }
    struct UsePassword {
        static let header = "usePassword-header"
        static let passwordIncorrect = "usePassword-passwordIncorrect"
    }
    struct WebAuthnTest {
        static let info = "webAuthnTest-info"
        static let browserPrompt = "webAuthnTest-browserPrompt"
        static let start = "webAuthnTest-start"
    }
    struct AffiliationMissing {
        static let header = "affiliationMissing-header"
        static let info = "affiliationMissing-info"
        static let proceed = "affiliationMissing-proceed"
        static let proceedLink = "affiliationMissing-proceedLink"
        static let retryLink = "affiliationMissing-retryLink"
    }
    struct ValidNameMissing {
        static let header = "validNameMissing-header"
        static let info = "validNameMissing-info"
        static let proceed = "validNameMissing-proceed"
        static let proceedLink = "validNameMissing-proceedLink"
        static let retryLink = "validNameMissing-retryLink"
    }
    struct StepUpExplanation {
        static let linked_institution = "stepUpExplanation-linked_institution"
        static let validate_names = "stepUpExplanation-validate_names"
        static let affiliation_student = "stepUpExplanation-affiliation_student"
    }
    struct StepUpVerification {
        static let linked_institution = "stepUpVerification-linked_institution"
        static let validate_names = "stepUpVerification-validate_names"
        static let affiliation_student = "stepUpVerification-affiliation_student"
    }
    struct NudgeApp {
        static let new = "nudgeApp-new"
        static let header = "nudgeApp-header"
        static let info = "nudgeApp-info"
        static let no = "nudgeApp-no"
        static let noLink = "nudgeApp-noLink"
        static let yes = "nudgeApp-yes"
        static let yesLink = "nudgeApp-yesLink"
    }
    struct AppRequired {
        static let header = "appRequired-header"
        static let info = "appRequired-info"
        static let info2 = "appRequired-info2"
        static let cancel = "appRequired-cancel"
        static let no = "appRequired-no"
        static let yesLink = "appRequired-yesLink"
        static let yes = "appRequired-yes"
        static let warning = "appRequired-warning"
        static let warningTitle = "appRequired-warningTitle"
        static let confirmLabel = "appRequired-confirmLabel"
        static let cancelLabel = "appRequired-cancelLabel"
    }
    struct SubContent {
        static let warningTitle = "subContent-warningTitle"
        static let warning = "subContent-warning"
        static let confirmLabel = "subContent-confirmLabel"
        static let cancelLabel = "subContent-cancelLabel"
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
