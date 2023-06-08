
var english = {
    sidebar: {
        home: "Home",
        personalInfo: "Personal info",
        dataActivity: "Data & activity",
        security: "Security",
        account: "Account"
    },
    start: {
        hi: "Hi {{name}}!",
        manage: "Manage your personal info, your privacy, and the security of your eduID account."
    },
    header: {
        title: "eduID",
        logout: "Logout"
    },
    landing: {
        logoutTitle: "You have been logged out",
        logoutStatus: "To finalise the logout process you must now close this browser.",
        loginAgain: "Login again",
        deleteTitle: "Your eduID account has been deleted",
        deleteStatus: "To finalise the removal process you must now close this browser.",
        registerAgain: "Register again"
    },
    notFound: {
        title: "Whoops...",
        title2: "Something went wrong (404)."
    },
    profile: {
        title: "Personal information",
        info: "When you use eduID to login to other websites, some of your personal information will be shared. Some websites require that your personal information is validated by a third party.",
        basic: "Basic information",
        email: "Email address",
        name: "Name",
        validated: "Validated information",
        firstAndLastName: "First and last name",
        firstAndLastNameInfo: "Your first and lastname are not yet verified by a third party",
        verify: "Verify",
        student: "Proof of student",
        studentInfo: "You have not yet proven that you are a student in the Netherlands.",
        prove: "Prove",
        trusted: "Link with third party",
        trustedInfo: "You eduID account is not yet linked to a third party",
        link: "Link",
        institution: "Institution",
        affiliations: "Affiliation(s)",
        expires: "Link expires",
        expiresValue: "{{date}}",
        verifiedAt: "Verified by <strong>{{name}}</strong> on {{date}}",
        proceed: "Proceed",
        verifyFirstAndLastName: {
            addInstitution: "Verify name",
            addInstitutionConfirmation: "When you proceed you will be asked to login at the institution you want to link to your eduID. First, select which institution you want to connect; then, login at that institution.<br/><br/>After a successful login you will come back here.",
        },
        verifyStudent: {
            addInstitution: "Prove student",
            addInstitutionConfirmation: "When you proceed you will be asked to login at the institution you want to link to your eduID. First, select which institution you want to connect; then, login at that institution.<br/><br/>After a successful login you will come back here.",
        },
        verifyParty: {
            addInstitution: "Link party",
            addInstitutionConfirmation: "When you proceed you will be asked to login at the institution you want to link to your eduID. First, select which institution you want to connect; then, login at that institution.<br/><br/>After a successful login you will come back here.",
        }
    },
    eppnAlreadyLinked: {
        header: "Connection not added!",
        info: "Your eduID could not be linked. The trusted account with which you just logged in, is already linked to a different eduID account: {{email}}.",
        infoNew: "You can't request an eduID account with the trusted account with which you just logged in. This institutional account is already linked to a different eduID account: {{email}}.",
        retryLink: "Retry"
    },
    edit: {
        title: "Name",
        info: "Please provide your full name",
        givenName: "Your first name",
        familyName: "Your last name",
        update: "Update",
        cancel: "Cancel",
        updated: "Your profile has been updated",
        back: "/personal"
    },
    email: {
        title: "Email",
        info: "Please enter your new email address. A verification mail will be sent to this address.",
        email: "Your new email",
        update: "Request",
        cancel: "Cancel",
        updated: "A verification email has been sent to {{email}}",
        confirmed: "Your email address has been changed to {{email}}",
        back: "/personal",
        emailEquality: "Your new email address is the same as your current email",
        duplicateEmail: "This email address is already in use.",
        outstandingPasswordForgotten: "Outstanding password forgotten request",
        outstandingPasswordForgottenConfirmation: "You have requested a password forgotten link. This link will no longer be valid if you confirm your email change."
    },
    security: {
        title: "Security settings",
        subTitle: "We provide different methods to sign in to your eduID account.",
        secondSubTitle: "Other sign-in methods",
        usePassword: "Password",
        usePublicKey: "WebAuthn",
        notSet: "Not set",
        notSupported: "Not supported",
        useMagicLink: "Send magic link to",
        rememberMe: "Stay logged in",
        securityKey: "Security key {{nbr}}",
        test: "Test",
        addSecurityKey: "Add security key",
        addSecurityKeyInfo: "You can add security keys to your eduID account which can be used to login. You can use, for example, the built-in sensor of your device (TouchID, FaceID) or a separate hardware key (YubiKey).",
        settings: "Sign-in settings",
        rememberMeInfo: "<strong>Your device is currently remembered. You will be automatically logged in to eduID.</strong>",
        noRememberMeInfo: "When logging in with your eduID, you can choose to <strong>stay logged in</strong>. This remembers your login on the device you use at that moment.",
        forgetMe: "Forget me",
        tiqr: {
            title: "Want to sign in quicker and more secure next time?",
            info: "Get the <strong>eduID app</strong> and securely sign in without passwords or accessing your email.",
            fetch: "Get it now",
            deactivate: "Deactivate",
            backupCodes: "Recovery method",
            app: "eduID app",
            phoneId: "Phone ID",
            APNS: "iPhone",
            APNS_DIRECT: "iPhone",
            FCM: "Android",
            GCM: "Android",
            FCM_DIRECT: "Android",
            appCode: "Appcode",
            lastLogin: "Last login",
            activated: "Activated on",
            dateTimeOn: "on",
            backupMethod: "Recovery method",
            sms: "SMS",
            code: "Backup code"
        }
    },
    home: {
        home: "Home",
        welcome: "Welcome {{name}}",
        "data-activity": "Data & activity",
        personal: "Personal info",
        security: "Security",
        account: "Account",
        institutions: "Connections",
        services: "Services",
        favorites: "Favorites",
        settings: "Settings",
        links: {
            teams: "Teams",
            teamsHref: "https://teams.{{baseDomain}}"
        }
    },
    account: {
        title: "Your account",
        titleDelete: "Delete your eduID account",
        info: "On this page you can manage your account.",
        created: "Created on",
        delete: "Delete my account",
        cancel: "Cancel",
        deleteInfo: "Proceed with care, as you will lose the unique eduID identifiers currently associated wth your email address.",
        data: "Download your data",
        personalInfo: "Click the button left to download all your personal data from your eduID account.",
        downloadData: "Download",
        downloadDataConfirmation: "The download of your personal data from your eduID account contains all the information we have about you. It also contains technical keys and references.",
        deleteTitle: "Deleting your eduID account",
        info1: "You can delete your eduID whenever you want.",
        info2: "Proceed with care, as you will lose the unique eduID number currently associated with your email address. When you re-register for a new eduID with that same email address, you will receive a new eduID number. Some services use this unique number to identify you, so for those services you will be treated as a new user.",
        info3: "Please note that deleting your eduID account does not mean all services you accessed with that eduID account will also have your data removed.",
        info4: "To fully complete the process of deleting your eduID account you must close your browser after your account has been removed.",
        deleteAccount: "Delete my account",
        deleteAccountConfirmation: "Are you sure you want to delete your eduID account?",
        deleteAccountSure: "Delete your account for all eternity?",
        deleteAccountWarning: "There is no way to undo this action.",
        proceed: "If you wish to proceed, please type in your full name for confirmation.",
        name: "Full name",
        namePlaceholder: "Your full name as used on your profile"
    },
    dataActivity: {
        title: "Data & Activity",
        info: "Each service you accessed through eduID receives certain personal data (attributes) from your eduID account. For example, your name, your email address or a pseudonym which the service can use to uniquely identify you.",
        explanation: "Apps you logged in to using eduID.",
        noServices: "You did not yet use eduID to login to any service.",
        name: "Name",
        add: "Connect new institution",
        access: "Can access your data",
        details: {
            login: "Login details",
            delete: "Delete login details",
            first: "First login",
            eduID: "Unique eduID",
            homePage: "Homepage",
            deleteDisclaimer: "Deleting these login details means eduID removes this information from your eduID account. You still have an account at the service itself. If you want that removed, please do so at the service.",
            access: "Access rights",
            details: "Access details",
            consent: "Date of consent",
            expires: "Date of expiry",
            revoke: "Revoke access"
        },
        deleteService: "Delete service",
        deleteServiceConfirmation: "Are you sure you want to delete your unique pseudonymised eduID for {{name}} and revoke access to your linked accounts?<br/><br/>This service might not recognize you the next time you login and all your personal data within this service might be lost.",
        deleteTokenConfirmation: "Are you sure you want to revoke the API access token for {{name}}?",
        deleteToken: "Revoke access token",
        deleted: "eduID removed",
        tokenDeleted: "Tokens removed"

    },
    institution: {
        title: "Connected institution",
        info: "This institution was connected to your eduID account on {{date}} at {{hours}}:{{minutes}}",
        name: "Institution name",
        eppn: "Identifier at institution",
        displayName: "Display name",
        affiliations: "Affiliation(s) at institution",
        expires: "This connection expires at",
        expiresValue: "{{date}}",
        delete: "Remove connection",
        cancel: "Cancel",
        deleted: "The connection with your institution {{name}} has been removed",
        back: "/institutions",
        deleteInstitution: "Delete institution",
        deleteInstitutionConfirmation: "Are you sure you want to delete the connection with this institution?<br/><br/>Some services require that you your eduID is connected to an institution. You might be prompted to connect an institution if you access one of those services."
    },
    credential: {
        title: "Edit security key",
        info: "You added this security key on {{date}} at {{hours}}:{{minutes}}",
        name: "Security key name",
        cancel: "Cancel",
        update: "Update",
        deleted: "Your security key {{name}} has been deleted",
        updated: "Your security key {{name}} has been updated",
        back: "/weauthn",
        deleteCredential: "Delete security key",
        deleteCredentialConfirmation: "Are you sure you want to delete your security key {{name}}? The secuirity key will be deleted from your eduID account, but will not be removed from your browser and / or Yubikey device."
    },
    password: {
        addTitle: "Add password",
        updateTitle: "Change password",
        addInfo: "If you want to add a password to your eduID account, press <strong>Confirm</strong> below to instantly receive an email with a link to add a password.",
        updateInfo: "If you want to reset or delete your password from your eduID account, press <strong>Confirm</strong> below to instantly receive an email with a link to change or delete your current password.",
        resetTitle: "Reset your password",
        newPassword: "New password",
        confirmPassword: "Confirm new password",
        setUpdate: "Set password",
        updateUpdate: "Update password",
        cancel: "Cancel",
        set: "Your password has been set",
        reset: "Your password has been reset to a new password",
        updated: "Your password has been updated",
        deleted: "Your password has been deleted",
        deletePassword: "Delete password",
        deletePasswordConfirmation: "Are you sure that you want to delete your password? Login with a password will be no longer possible.",
        back: "/security",
        passwordDisclaimer: "Make sure it's at least 15 characters OR at least 8 characters including a number and a uppercase letter.",
        invalidCurrentPassword: "Your current password is invalid.",
        passwordResetHashExpired: "Your password reset link has expired. ",
        forgotPassword: "Help! I forgot my current password",
        passwordResetSendAgain: "Send an email to reset my password.",
        forgotPasswordConfirmation: "Forgot your password? Press 'Confirm' below to instantly receive an email with a link to reset your current password.",
        outstandingEmailReset: "Outstanding email change request",
        outstandingEmailResetConfirmation: "You have an outstanding new email confirmation link. This link will no longer be valid if you confirm your password forgotten request.",
        flash: {
            passwordLink: "An email has been sent to {{name}} with a link to reset your password"
        }
    },
    webauthn: {
        setTitle: "Add security key",
        updateTitle: "Add security key",
        publicKeys: "Your public tokens",
        noPublicKeys: "You have not added any security keys. ",
        nameRequired: "Before you can add a new security key you must give it a name.",
        revoke: "Revoke",
        addDevice: "Add device",
        info: "You can choose to use a Bluetooth security key, USB security key or the security key built into your device.",
        back: "/security",
        setUpdate: "Start",
        updateUpdate: "Add device",
        credentialName: "Security key",
        credentialNamePlaceholder: "e.g. my red Yubikey",
        test: "Test",
        testInfo: "Click the <strong>test</strong> button to test one of your security keys. You will be redirected to the eduID login screen.",
        testFlash: "You successfully tested your security key to authenticate"
    },
    rememberMe: {
        updated: "Your device is no longer remembered",
        forgetMeTitle: "Remember this device.",
        info: "Your device is currently remembered. You will be automatically logged in to eduID.",
        cancel: "Cancel",
        update: "Forget me",
        forgetMeConfirmation: "Are you sure you no longer want this device remembered?",
        forgetMe: "Forget this device"
    },
    footer: {
        privacy: "Privacy policy",
        terms: "Terms of Use",
        help: "Help",
        poweredBy: "Powered by"
    },
    modal: {
        cancel: "Cancel",
        confirm: "Confirm"
    },
    format: {
        creationDate: "{{date}} at {{hours}}:{{minutes}}"
    },
    getApp: {
        header: "Download the eduID app",
        info: "Download and install <a href=\"https://eduid.nl/help\" target=\"_blank\">the eduID app</a> (issued by SURF) on your mobile device.",
        google: "https://play.google.com/apps/testing/nl.eduid",
        apple: "https://testflight.apple.com/join/Ogk1TxKu",
        after: "When you've downloaded the eduID app on your phone, come back here and click next.",
        back: "Back",
        next: "Next"
    },
    sms: {
        header: "Check your phone",
        info: "Enter the six-digit code we sent to your phone to continue",
        codeIncorrect: "The code is incorrect",
        maxAttemptsPre: "Max attempts reached. Click",
        maxAttemptsPost: "to re-enter your phone number and receive a new verification",
        maxAttemptsPostNoReEnter: "to request a new verification",
        here: " here "
    },
    enrollApp: {
        header: "Finish setup in the eduID app",
        scan: "Scan this QR code with your eduID app",
        timeOut: "Session timeout",
        timeOutInfoFirst: "Your session timed out. Click this ",
        timeOutInfoLast: " to try again.",
        timeOutInfoLink: "link",
        openEduIDApp: "Open the app on this device"
    },
    recovery: {
        header: "Set up a recovery method",
        changeHeader: "Change your recovery method",
        info: "If you can no longer use the eduID app, for example if your mobile phone is lost, you can register the eduID app again using the recovery method.",
        changeInfo: "You have successfully authenticated with the eduID app. You can now change your recovery method. ATTENTION: your current recovery method will be deactivated.",
        methods: "The following methods are available.",
        phoneNumber: "Add a recovery phone number.",
        phoneNumberInfo: "You'll receive a text message with a code.",
        backupCode: "Request a recovery code.",
        backupCodeInfo: "Keep this code in a safe place.",
        save: "Save the code somewhere safe.",
        active: "This code is now active and your eduID app is ready to use.",
        copy: "Copy the code",
        copied: "Copied",
        continue: "My code is safe. Continue",
        leaveConfirmation: "Are you sure you want to leave the page? Changes will not be saved."
    },
    phoneVerification: {
        header: "Add a recovery phone number",
        info: "Your phone number will be used for security purposes, so that you can re-register the eduID app if you lose it.",
        text: "We will text you a code to verify your number",
        verify: "Verify this phone number",
        placeHolder: "+31 612345678",
        phoneIncorrect: "Verification code is incorrect"
    },
    congrats: {
        header: "Success",
        info: "You can now use the eduID app to quickly log in to services that use eduID.",
        changeInfo: "You have changed your recovery method.",
        next: "Back to settings"
    },
    deactivate: {
        titleDelete: "Deactivate your eduID app",
        info: "You can deactivate your eduID app if you want to reinstall this app or if you have a new device.",
        recoveryCode: "Recovery code",
        recoveryCodeInfo: "Enter the <strong>recovery code</strong> you've saved during the eduID app registration.",
        verificationCode: "Text message verification code",
        codeIncorrect: "Wrong recovery code",
        next: "Next",
        deactivateApp: "Deactivate",
        sendSms: "Press next to send a verification code text message to your registered phone number",
        maxAttempts: "Max attempts used. Please contact <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> for support"
    },
    backupCodes: {
        title: "Recovery method",
        info: "You have installed and registered the eduID app. To change your recovery method, you must first authenticate with the eduID app.",
        phoneNumber: "Phone number",
        startTiqrAuthentication: "Change",
        code: "Code"
    },
    useApp: {
        header: "Check your eduID app",
        info: "We have sent a push-notification to your app, to verify it's you trying to sign in.",
        scan: "Scan this QR code with your eduID app",
        noNotification: "No notification?",
        qrCodeLink: "Create a QR-code",
        qrCodePostfix: "and scan it.",
        offline: "When your device is offline, you must enter a",
        offlineLink: "one time code.",
        lost: "Lost your app?",
        lostLink: "Learn <a href=\"https://eduid.nl/help\" target=\"_blank\">how to register a new one</a>.",
        timeOut: "Session timeout",
        timeOutInfoFirst: "Your session timed out. Click this ",
        timeOutInfoLast: " to try again.",
        timeOutInfoLink: "link",
        responseIncorrect: "The response is invalid.",
        suspendedResult: "The verification from your eduID app failed. ",
        accountNotSuspended: "You can try again.",
        accountSuspended: "You'll have to wait {{minutes}} {{plural}} before you can try again.",
        minutes: "minutes",
        minute: "minute"
    },
    createFromInstitution: {
        title: "Create an eduID from your institution",
        header: "You are about to create an eduID account that will be linked to your institution account.",
        alreadyHaveAnEduID: "Already have an eduID account? <a href=\"{{location}}\">Login!</a>",
        info: "When you proceed you will be asked to login at the institution you want to link to your eduID. After a successful login you will come back here.",
        startFlow: "Start registration",
        welcome: "Your eduID account has been created",
        welcomeExisting: "Your eduID account has been linked to your insitutional account"
    },
    linkFromInstitution: {
        header: "Hi {{name}}",
        info: "You have successfully logged in at your institution. Please enter your personal email which will be your eduID email.",
        email: "Your email address",
        emailPlaceholder: "e.g. user@gmail.com",
        emailForbidden: "The creation of an eduID account for this email-domain is denied, please contact <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> if you think this email-domain is valid.",
        emailInUse1: "This email is already in use.",
        emailInUse2: "Try another, or ",
        emailInUse3: " link with this eduID account.",
        invalidEmail: "Invalid email",
        institutionDomainNameWarning: "It looks like you entered an institutional email address. Please note that when you no longer study at or work for that institution, you can no longer use that email address.",
        institutionDomainNameWarning2: "We recommend using your personal email address for eduID.",
        allowedDomainNamesError: "Domain name {{domain}} not allowed.",
        allowedDomainNamesError2: "eduID is restricted to be used only for allowed domains.",
        agreeWithTerms: "<span>I agree with <a tabindex='-1' href='https://eduid.nl/terms-of-use/' target='_blank'>the terms of service.</a> I also understand <a tabindex='-1' href='https://eduid.nl/privacy_policy/' target='_blank'>the privacy policy</a>.</span>",
        requestEduIdButton: "Request your eduID",
    },
    pollFromInstitution: {
        header: "Check your email!",
        info: "To sign in, click the link in the email we sent to <strong>{{email}}</strong>.",
        awaiting: "Waiting for you to click the link...",
        openGMail: "Open Gmail.com",
        openOutlook: "Open Outlook.com",
        spam: "Can't find the email? Check your spam folder.",
        loggedIn: "Login succeeded!",
        loggedInInfo: "You can close this tab / window.",
        timeOutReached: "Timeout!",
        timeOutReachedInfo: "Your link has expired. Please go back to the service you where heading to and try again.",
        resend: "Still can't find the email?",
        resendLink: "Send the email again.",
        mailResend: "Check your inbox again. We've sent another email with a validation link.",
    },
    login: {
        requestEduId: "No eduID?",
        requestEduId2: "Create one!",
        loginEduId: "Login!",
        whatis: "What is eduID?",
        header: "Sign in with eduID",
        headerSubTitle: "to continue to ",
        header2: "Request your eduID",
        trust: "Trust this computer",
        loginOptions: "Other sign-in options",
        loginOptionsToolTip: "We offer 3 ways to sign-in:</br><ol>" +
            "<li>You can receive a magic link sent to your email address.</li>" +
            "<li>You can use a password. You must first set this up in My eduID.</li>" +
            "<li>You can use a security key. You must first set this up in My eduID.</li>" +
            "</ol>",
        email: "Your email address",
        emailPlaceholder: "e.g. user@gmail.com",
        passwordPlaceholder: "Password",
        familyName: "Last name",
        givenName: "First name",
        familyNamePlaceholder: "e.g. Berners-Lee",
        givenNamePlaceholder: "e.g. Tim",
        sendMagicLink: "Email a magic link",
        loginWebAuthn: "Login with security key",
        usePassword: "type a password.",
        usePasswordNoWebAuthn: "Type a password.",
        useMagicLink: "Email a magic link",
        useMagicLinkNoWebAuthn: "Email a magic link.",
        useWebAuth: "Sign in with a security key",
        useOr: "or",
        requestEduIdButton: "Request your eduID",
        rememberMe: "Stay logged in",
        password: "Your password",
        passwordForgotten: "Forgot your password or prefer a magic link? ",
        passwordForgottenLink: "Receive an email to sign in instantly.",
        login: "Login",
        create: "Create",
        newTo: "New to eduID?",
        createAccount: " Create an account.",
        useExistingAccount: "Use existing account",
        invalidEmail: "Invalid email",
        requiredAttribute: "{{attr}} is required",
        emailInUse1: "This email is already in use.",
        emailInUse2: "Try another, or ",
        emailInUse3: " login with this eduID account.",
        emailForbidden: "The creation of an eduID account for this email-domain is denied, please contact <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> if you think this email-domain is valid.",
        emailNotFound1: "We could not find an eduID with that email.",
        emailNotFound2: "Try another, or ",
        emailNotFound3: "create a new eduID account.",
        emailOrPasswordIncorrect: "Email or password are incorrect",
        institutionDomainNameWarning: "It looks like you entered an institutional email address. Please note that when you no longer study at or work for that institution, you can no longer use that email address.",
        institutionDomainNameWarning2: "We recommend using your personal email address for eduID.",
        allowedDomainNamesError: "Domain name {{domain}} not allowed.",
        allowedDomainNamesError2: "eduID is restricted to be used only for allowed domains.",
        passwordDisclaimer: "Make sure it's at least 15 characters long OR at least 8 characters when including a number and an UpperCase letter.",
        alreadyGuestAccount: "Already have an eduID?",
        usePasswordLink: "Type a password anyway",
        useWebAuthnLink: "Or use a security key",
        agreeWithTerms: "<span>I agree with <a tabindex='-1' href='https://eduid.nl/terms-of-use/' target='_blank'>the terms of service.</a> I also understand <a tabindex='-1' href='https://eduid.nl/privacy_policy/' target='_blank'>the privacy policy</a>.</span>",
        next: "Next",
        useOtherAccount: "Use another account",
        noAppAccess: "No access to your app?",
        noMailAccess: "No access to your mail?",
        forgotPassword: "Forgot your password?",
        useAnother: "Use another",
        optionsLink: "sign-in option.",
    },
    options: {
        header: "How do you want to login?",
        noLogin: "Still not able to login?",
        learn: "Learn how to",
        learnLink: "recover your acccount",
        useApp: "Use the <strong>eduID app</strong> to sign in with your mobile device.",
        useWebAuthn: "Use your <strong>security key</strong>.",
        useLink: "Get a <strong>magic link</strong> sent to your inbox.",
        usePassword: "Use <strong>a password</strong>.",
    },
    magicLink: {
        header: "Check your email!",
        info: "To sign in, click the link in the email we sent to <strong>{{email}}</strong>.",
        awaiting: "Waiting for you to click the link...",
        openGMail: "Open Gmail.com",
        openOutlook: "Open Outlook.com",
        spam: "Can't find the email? Check your spam folder.",
        loggedIn: "Login succeeded!",
        loggedInInfo: "You can close this tab / window.",
        timeOutReached: "Timeout!",
        timeOutReachedInfo: "Your link has expired. Please go back to the service you where heading to and try again.",
        resend: "Still can't find the email?",
        resendLink: "Send the email again.",
        mailResend: "Check your inbox again. We've sent another email with a magic link.",
        loggedInDifferentDevice: "Verification code required",
        loggedInDifferentDeviceInInfo: "The magic link we sent you opened in a different browser than the one used to request the magic link. As an extra security measure you must enter a verification code.",
        loggedInDifferentDeviceInInfo2: "We sent you an extra email with the verification code.",
        verificationCodeError: "Wrong verification code.",
        verify: "Verify"
    },
    confirm: {
        header: "Success!",
        thanks: "Your eduID account has been created. Proceed to your destination.",
    },
    confirmStepup: {
        header: "Thanks!",
        proceed: "Go to {{name}}",
        conditionMet: "All conditions are met."
    },
    stepup: {
        header: "One more thing!",
        info: "To proceed to <strong>{{name}}</strong>, you must meet the following condition(s).",
        link: "Verify this via SURFconext",
        linkExternalValidation: "Verify this via ReadID"
    },
    footer: {
        privacy: "Privacy policy",
        terms: "Terms of Use",
        help: "Help",
        poweredBy: "Powered by"
    },
    success: {
        title: "Login almost done!",
        info: "Please go back to the screen where you requested the magic link and follow the instructions there.<br/><br/>You can close this tab / window."
    },
    expired: {
        title: "Expired magic link",
        info: "The magic link you used is either expired or has already been used.",
        back: "Go to eduid.nl"
    },
    maxAttempt: {
        title: "Maximum attempts reached",
        info: "You've reached the maximum verification attempts.",
    },
    notFound: {
        title: "Whoops...",
        title2: "Something went wrong (404)"
    },
    webAuthn: {
        info: "Add security key",
        browserPrompt: "Click the button below to add a security key to your eduID account. Please follow the instructions given by your browser.",
        start: "Start",
        header: "Sign in with a security key",
        explanation: "Your device will open a security window. Follow the instructions there to sign in.",
        next: "Log in with a security key",
        error: "Currently you can not use your security key to login."
    },
    useLink: {
        header: "Request a magic link",
        next: "Email a magic link"
    },
    usePassword: {
        header: "Enter your password",
        passwordIncorrect: "Password is incorrect"
    },
    useApp: {
        header: "Check your eduID app",
        info: "We have sent a push-notification to your app, to verify it's you trying to sign in.",
        scan: "Scan this QR code with your eduID app",
        noNotification: "No notification?",
        qrCodeLink: "Create a QR-code",
        qrCodePostfix: "and scan it.",
        offline: "When your device is offline, you must enter a",
        offlineLink: "one time code.",
        openEduIDApp: "Open the app on this device",
        lost: "Lost your app?",
        lostLink: "Learn <a href=\"https://eduid.nl/help\" target=\"_blank\">how to register a new one</a>.",
        timeOut: "Session timeout",
        timeOutInfoFirst: "Your session timed out. Click this ",
        timeOutInfoLast: " to try again.",
        timeOutInfoLink: "link",
        responseIncorrect: "The response is invalid.",
        suspendedResult: "The verification from your eduID app failed. ",
        accountNotSuspended: "You can try again.",
        accountSuspended: "You'll have to wait {{minutes}} {{plural}} before you can try again.",
        minutes: "minutes",
        minute: "minute"
    },
    enrollApp: {
        header: "Finish setup in the eduID app"
    },
    recovery: {
        header: "Set up a recovery method",
        info: "If you can't access eduID with the app or via email, you can use a recovery method to sign in to your eduID account.",
        methods: "The following methods are available.",
        phoneNumber: "Add a recovery phone number.",
        phoneNumberInfo: "You'll receive a text message with a code.",
        backupCode: "Request a recovery code.",
        backupCodeInfo: "The code can be used to sign in with.",
        save: "Save the code somewhere safe.",
        active: "This code is active now, but you can generate a new code within My-eduID anytime.",
        copy: "Copy the code",
        copied: "Copied",
        continue: "My code is safe. Continue",
        leaveConfirmation: "Are you sure you want to leave the page? Changes will not be saved."
    },
    phoneVerification: {
        header: "Add a recovery phone number",
        info: "Your phone number will be used for security purposes, such as helping you get back into your account if you ever lose your app",
        text: "We will text you a code to verify your number",
        verify: "Verify this phone number",
        placeHolder: "+31 612345678",
        phoneIncorrect: "Phone number is incorrect"
    },
    congrats: {
        header: "Success",
        info: "You can now use the eduID app to quickly login to services which require you to login with your eduID.",
        next: "Onwards to {{name}}"
    },
    webAuthnTest: {
        info: "Test security key",
        browserPrompt: "Click the button below to test a security key. Please follow the instructions given by your browser.",
        start: "Test"
    },
    affiliationMissing: {
        header: "Account linked, but...",
        info: "Your eduID is successfully linked, however the institution you choose did not provide the correct affiliation.",
        proceed: "You can try to link to another institution or proceed to {{name}}.",
        proceedLink: "Proceed",
        retryLink: "Retry"
    },
    eppnAlreadyLinked: {
        header: "Account not linked!",
        info: "Your eduID could not be linked. The trusted account with which you just logged in, is already linked to a different eduID account: {{email}}.",
        proceed: "You can try to link to another institution or proceed to {{name}}.",
        proceedLink: "Proceed",
        retryLink: "Retry"
    },
    validNameMissing: {
        header: "Account linked, but...",
        info: "Your eduID is successfully linked, however the institution you choose did not provide a valid name.",
        proceed: "You can try to link to another institution or proceed to {{name}}.",
        proceedLink: "Proceed",
        retryLink: "Retry"
    },
    stepUpExplanation: {
        linked_institution: "Your eduID account must be linked to a trusted party.",
        validate_names: "Your first name and last name must be verified by a trusted party.",
        affiliation_student: "You must prove that you are following education by linking your eduID account to a trusted party."
    },
    stepUpVerification: {
        linked_institution: "Your eduID account is linked to a trusted party.",
        validate_names: "Your first name and last name are verified by a trusted party.",
        affiliation_student: "You have proven that you are following education by linking your eduID account to a trusted party."
    },
    nudgeApp: {
        new: "Your eduID account has been created!",
        header: "Want to sign in quicker and more secure next time?",
        info: "Get the <strong>eduID app</strong> and securely sign in without passwords or accessing your email. It will only take a minute.",
        no: "No thanks",
        noLink: "/proceed",
        yes: "Get it now",
        yesLink: "/eduid-app"
    },
    getApp: {
        header: "Download the eduID app",
        info: "Download and install <a href=\"https://eduid.nl/help\" target=\"_blank\">the eduID app</a> (issued by SURF) on your mobile device.",
        google: "https://play.google.com/store/apps/details?id=nl.eduid",
        apple: "https://apps.apple.com/",
        after: "When you've downloaded the eduID app on your phone, come back here and click next.",
        back: "Back",
        next: "Next"
    },
    sms: {
        header: "Check your phone",
        info: "Enter the six-digit code we sent to your phone to continue",
        codeIncorrect: "The code is incorrect",
        sendSMSAgain: "Resend code",
        maxAttemptsPre: "Max attempts reached. Click",
        maxAttemptsPost: "to use a different phone number or resend code to receive a new verification",
        here: " here "
    },
    rememberMe: {
        yes: "Yes",
        no: "No",
        header: "Stay signed in?",
        info: "Stay signed in on this device so you don't have to sign in next time."
    },
    modal: {
        cancel: "Cancel",
        confirm: "Confirm",
    },
    appRequired: {
        header: "Login with the eduID app",
        info: "Login with the eduID app to ensure your identity.",
        info2: "Get the <strong>eduID app</strong> and securely sign in without passwords or accessing your email. It will only take a minute. Please click <strong>Proceed</strong> for the next step.",
        cancel: "/cancel",
        no: "I refuse",
        yesLink: "/proceed",
        yes: "Proceed",
        warning: "Login without the eduApp is strongly discouraged. The service {{service}} will not receive your attributes.",
        warningTitle: "Get the eduApp",
        confirmLabel: "Get the eduApp",
        cancelLabel: "I still refuse"
    },
    subContent: {
        warningTitle: "Please reconsider",
        warning: "The service your logging into has explicitly requested you login using your eduID app. If you login with a different method, this service will not receive your attributes.",
        confirmLabel: "Change login option anyway",
        cancelLabel: "Did not know that"
    }
};

var dutch = {
    sidebar: {
        home: "Home",
        personalInfo: "Persoonlijke info",
        dataActivity: "Data & activiteit",
        security: "Beveiliging",
        account: "Account"
    },
    start: {
        hi: "Hi {{name}}!",
        manage: "Beheer jouw persoonlijke informatie, jouw privacy, en de beveiliging van jouw eduID account."
    },
    header: {
        title: "eduID",
        logout: "Uitloggen"
    },
    landing: {
        logoutTitle: "Je bent uitgelogd",
        logoutStatus: "Om het uitlogproces te voltooien, moet je de browser nu afsluiten.",
        loginAgain: "Opnieuw inloggen",
        deleteTitle: "Jouw eduID is verwijderd",
        deleteStatus: "Om het verwijderen van je eduID te voltooien, moet je jouw browser nu afsluiten.",
        registerAgain: "Opnieuw registreren"
    },
    notFound: {
        title: "Oeps...",
        title2: "Er is iets fout gegaan (404)."
    },
    profile: {
        title: "Persoonlijke informatie",
        info: "Wanneer je eduID gebruikt om in te loggen op andere websites, kan jouw persoonlijke informatie worden gedeeld. Sommige websites vereisen dat je persoonlijke gegevens worden gevalideerd door een derde partij.",
        basic: "Basis informatie",
        email: "E-mail",
        name: "Naam",
        validated: "Gevalideerde informatie",
        firstAndLastName: "Voor- en achternaam",
        firstAndLastNameInfo: "Jouw voor- en achternaam zijn nog niet geverifieerd door een derde partij.",
        verify: "Verifïeer",
        student: "Bewijs van studeren",
        studentInfo: "Je hebt nog niet bewezen dat je in Nederland een studie volgt.",
        prove: "Bewijs",
        trusted: "Koppeling met vertrouwde partij",
        trustedInfo: "Je eduID account is nog niet gekoppeld aan een vertrouwde partij.",
        link: "Koppel",
        institution: "Instelling",
        affiliations: "Betrekking(en)",
        expires: "Koppeling verloopt",
        expiresValue: "{{date}}",
        verifiedAt: "Geverifieerd door <strong>{{name}}</strong> op {{date}}",
        proceed: "Doorgaan",
        verifyFirstAndLastName: {
            addInstitution: "Verifieer naam",
            addInstitutionConfirmation: "Als je doorgaat word je gevraagd in te loggen via de onderwijsinstelling die je wilt koppelen. Selecteer eerst welke instelling je wilt koppelen en log daarna in.<br/> <br/>Nadat je succesvol bent ingelogd kom je hier weer terug.",
        },
        verifyStudent: {
            addInstitution: "Bewijs student",
            addInstitutionConfirmation: "Als je doorgaat word je gevraagd in te loggen via de onderwijsinstelling die je wilt koppelen. Selecteer eerst welke instelling je wilt koppelen en log daarna in.<br/> <br/>Nadat je succesvol bent ingelogd kom je hier weer terug.",
        },
        verifyParty: {
            addInstitution: "Koppel instelling",
            addInstitutionConfirmation: "Als je doorgaat word je gevraagd in te loggen via de onderwijsinstelling die je wilt koppelen. Selecteer eerst welke instelling je wilt koppelen en log daarna in.<br/> <br/>Nadat je succesvol bent ingelogd kom je hier weer terug.",
        }
    },
    eppnAlreadyLinked: {
        header: "Koppeling niet gemaakt!",
        info: "Je eduID kon niet worden gekoppeld. Het vertrouwde account waarmee je zojuist bent ingelogd, is al aan een ander eduID-account gekoppeld: {{email}}.",
        infoNew: "Je kan geen eduID account aanvragen met het vertrouwde account waarmee je zojuist bent ingelogd. Dit instellings-account is al gekoppeld met aan een ander eduID account: {{email}}.",
        retryLink: "Opnieuw proberen"
    },
    edit: {
        title: "Aanpassen profielgegevens",
        info: "Voer je volledige naam in.",
        givenName: "Je voornaam",
        familyName: "Je achternaam",
        update: "Opslaan",
        cancel: "Annuleren",
        updated: "Je profiel is bijgewerkt.",
        back: "/profile"
    },
    email: {
        title: "E-mail",
        info: "Voer je nieuwe e-mailadres in. Er wordt een verificatiemail naar dit adres gestuurd.",
        email: "Je nieuwe e-mail",
        update: "Verstuur",
        cancel: "Annuleer",
        updated: "Een verificatiemail is verzonden naar {{email}}",
        confirmed: "Je e-mail is gewijzigd naar {{email}}",
        back: "/personal",
        emailEquality: "Je nieuwe e-mailadres is gelijk aan je huidige e-mailadres",
        duplicateEmail: "Dit e-mailadres is al in gebruik.",
        outstandingPasswordForgotten: "Uitstaand reset verzoek voor wachtwoord",
        outstandingPasswordForgottenConfirmation: "Je hebt een openstaand wachtwoord vergeten link. Deze link is niet langer geldig als je deze e-mailwijziging bevestigt."
    },
    security: {
        title: "Beveiliging",
        subTitle: "We bieden verschillende methoden om in te loggen met je eduID.",
        secondSubTitle: "Andere loginmethoden",
        usePassword: "Wachtwoord",
        usePublicKey: "Beveiligingssleutel",
        notSet: "Niet ingesteld",
        notSupported: "Niet ondersteund",
        useMagicLink: "Stuur magische link naar",
        rememberMe: "Ingelogd blijven",
        securityKey: "Beveiligingssleutel {{nbr}}",
        test: "Test",
        addSecurityKey: "Beveiligingssleutel toevoegen",
        addSecurityKeyInfo: "Je kunt een beveiligingssleutel toevoegen aan je eduID account waarmee je kunt inloggen. Dit kan bijv. de ingebouwde sensor van je apparaat zijn (TouchID, FaceID) of een los hardwaretoken (YubiKey).",
        settings: "Instellingen voor inloggen",
        rememberMeInfo: "<strong> Dit apparaat wordt momenteel onthouden. Je wordt automatisch ingelogd op eduD </strong>",
        noRememberMeInfo: "Als je inlogt met eduID kun je ervoor kiezen om <strong>ingelogd te blijven</strong>. Dan wordt jouw login op het apparaat dat je op dat moment gebruikt onthouden.",
        forgetMe: "Vergeet dit apparaat",
        tiqr: {
            title: "Wil je de volgende keer sneller en veiliger inloggen?",
            info: "Download de <strong>eduID app</strong> en log veilig in zonder wachtwoord of toegang tot je e-mail.",
            fetch: "Nu installeren",
            deactivate: "Deactiveren",
            app: "eduID app",
            backupCodes: "Herstelmethode",
            phoneId: "Telefoon ID",
            APNS: "iPhone",
            APNS_DIRECT: "iPhone",
            FCM: "Android",
            GCM: "Android",
            FCM_DIRECT: "Android",
            appCode: "App code",
            lastLogin: "Laatste login",
            activated: "Geactiveerd op",
            dateTimeOn: "om",
            backupMethod: "Herstelmethode",
            sms: "SMS",
            code: "Herstelcode"
        }
    },
    home: {
        home: "Home",
        welcome: "Welkom {{name}}",
        "data-activity": "Data & activiteit",
        personal: "Persoonlijke info",
        security: "Beveiliging",
        account: "Account",
        institutions: "Koppelingen",
        services: "Diensten",
        favorites: "Favorieten",
        settings: "Instellingen",
        links: {
            teams: "Teams",
            teamsHref: "https://teams.{{baseDomain}}",
        }
    },
    account: {
        title: "Je eduID account",
        titleDelete: "Verwijder je eduID account",
        info: "Op deze pagina kun je je account beheren.",
        created: "Aangemaakt op",
        delete: "Verwijder mijn account",
        cancel: "Annuleer",
        deleteInfo: "Ga voorzichtig te werk, want je verliest de unieke eduID ID's die momenteel aan je e-mailadres zijn gekoppeld.",
        data: "Download je data",
        downloadData: "Download",
        downloadDataConfirmation: "De download van je persoonlijke gegevens van je eduID-account bevat alle informatie die we over je  hebben. Het bevat ook technische sleutels en referenties.",
        personalInfo: "Klik op de onderstaande knop om al je persoonlijke gegevens uit je eduID account te downloaden.",
        deleteTitle: "Je eduID account verwijderen",
        info1: "Je kunt je eduID account verwijderen wanneer je maar wilt.",
        info2: "Let op, je verliest de unieke eduID nummers die aan je e-mailadres zijn gekoppeld. Wanneer je je opnieuw registreert voor eduID met hetzelfde e-mailadres, krijg je een nieuwe eduID nummers. Sommige diensten gebruiken deze nummers om je uniek te identificeren, dus voor die diensten word je dan gezien als een nieuwe gebruiker. ",
        info3: "Houd er rekening mee dat het verwijderen van je eduID niet betekent dat alle diensten die je met je eduID hebt gebruikt, ook je gegevens zullen verwijderen.",
        info4: "Om het verwijderen van je eduID volledig te voltooien, moet je nadat je account is verwijderd je browser afsluiten.",
        deleteAccount: "Verwijder mijn eduID",
        deleteAccountConfirmation: "Weet je zeker dat je je eduID wilt verwijderen?",
        deleteAccountSure: "Je account voor alle eeuwigheid verwijderen?",
        deleteAccountWarning: "Er is geen manier om deze actie ongedaan te maken.",
        proceed: "Als je wilt doorgaan, typ dan je volledige naam zoals bekend in je eduID account ter bevestiging.",
        name: "Volledige naam",
        namePlaceholder: "Je volledige naam zoals gebruikt in je profiel"
    },
    dataActivity: {
        title: "Gebruikte diensten",
        info: "Elke dienst waarvoor je eduID gebruikt ontvangt bepaalde gegevens (attributen) vanuit jouw eduID account. Denk hierbij aan je naam, e-mailadres of aan een pseudoniem waarmee de dienst jou uniek kan identificeren.",
        explanation: "Diensten waarop je bent ingelogd via eduID.",
        noServices: "Je bent nog niet ingelogd geweest op een dienst via eduID.",
        name: "Naam",
        add: "Nieuwe instelling koppelen",
        access: "Heeft toegang tot je data",
        details: {
            login: "Logingegevens",
            delete: "Verwijder logingegevens",
            first: "Eerste login",
            eduID: "Uniek eduID nummer",
            homePage: "Home pagina",
            deleteDisclaimer: "Als je deze logingegevens verwijdert, verwijdert eduID deze informatie uit je eduID account. Je hebt nog een account bij de dienst zelf. Als je dat wilt laten verwijderen, doe dat dan rechtstreeks bij de dienst.",
            access: "Toegangsrechten",
            details: "Accountgegevens",
            consent: "Datum toestemming",
            expires: "Vervaldatum",
            revoke: "Intrekken"
        },
        deleteService: "Verwijder dienst",
        deleteServiceConfirmation: "Weet je zeker dat je het unieke gepseudonimiseerde eduID voor {{name}} wilt verwijderen? <br/> <br/> Deze dienst herkent je wellicht niet meer de volgende keer dat je inlogt en je persoonlijke gegevens bij deze dienst zijn daardoor mogelijk niet meer toegankelijk.",
        deleteTokenConfirmation: "Weet je zeker dat de API access beveiligingssleutel voor {{name}} wilt intrekken?",
        deleteToken: "Beveiligingssleutel intrekken",
        deleted: "eduID verwijderd",
        tokenDeleted: "Beveiligingssleutels verwijderd"
    },
    institution: {
        title: "Gekoppelde instelling",
        info: "Deze instelling is op {{date}} om {{hours}}: {{minutes}} gekoppeld aan jouw eduID.",
        name: "Naam van de instelling",
        eppn: "Identifier bij de instelling",
        displayName: "Weergavenaam",
        affiliations: "Betrekking(en) bij de instelling",
        expires: "Koppeling verloopt op",
        expiresValue: "{{date}}",
        delete: "Verwijder koppeling",
        cancel: "Annuleren",
        deleted: "De koppeling met instelling {{name}} is verwijderd",
        back: "/instellingen",
        deleteInstitution: "Verwijder koppeling",
        deleteInstitutionConfirmation: "Weet je zeker dat je de koppeling met deze instelling wilt verwijderen?<br/> <br/>Sommige diensten vereisen dat je een koppeling hebt met een onderwijsinstelling. Je wordt mogelijk gevraagd een instelling te koppelen als je één van die diensten gebruikt."
    },
    credential: {
        title: "Bewerk beveiligingssleutel",
        info: "Je hebt deze key toegevoegd op {{date}} om {{hours}}: {{minutes}}",
        name: "Naam",
        cancel: "Annuleren",
        update: "Bewaar",
        deleted: "Je key {{name}} is verwijderd",
        updated: "Je key {{name}} is bewaard",
        back: "/weauthn",
        deleteCredential: "Verwijder key",
        deleteCredentialConfirmation: "Weet je zeker dat je de beveiligingssleutel {{name}} wilt verwijderen? De beveiligingssleutel wordt verwijderd uit je eduID account, maar wordt niet verwijderd uit je browser en / of van je YubiKey-apparaat."
    },
    password: {
        addTitle: "Toevoegen wachtwoord",
        updateTitle: "Wijzig wachtwoord",
        addInfo: "Als je een wachtwoord aan je eduID-account wilt toevoegen, klik dan hieronder op <strong>Bevestigen</strong> om direct een e-mail te ontvangen met een link om een wachtwoord toe te voegen.",
        updateInfo: "Als je het wachtwoord van je eduID-account wilt resetten of verwijderen, druk hieronder op <strong>Bevestigen</strong> om direct een e-mail te ontvangen met een link om je huidige wachtwoord opnieuw in te stellen of te verwijderen.\n",
        resetTitle: "Stel je wachtwoord opnieuw in",
        newPassword: "Nieuw wachtwoord",
        confirmPassword: "Bevestig nieuw wachtwoord",
        setUpdate: "Wachtwoord instellen",
        updateUpdate: "Opslaan",
        cancel: "Annuleren",
        set: "Je wachtwoord is ingesteld",
        reset: "Je wachtwoord is opnieuw ingesteld",
        deleted: "Je wachtwoord is verwijderd",
        deletePassword: "Verwijder wachtwoord",
        deletePasswordConfirmation: "Weet je zeker dat je je wachtwoord wilt verwijderen? Het is hierna niet meer mogelijk om in te loggen met dit wachtwoord.",
        updated: "Je wachtwoord is aangepast",
        back: "/security",
        passwordDisclaimer: "Kies een wachtwoord van tenminste 8 karakters lang met minimaal een hoofdletter en een cijfer. Een langer wachtwoord van minimaal 15 karakters mag ook.",
        invalidCurrentPassword: "Je huidige wachtwoord is niet correct.",
        passwordResetHashExpired: "De link om je wachtwoord opnieuw in te stellen is verlopen. ",
        forgotPassword: "Help! Ik ben mijn huidige wachtwoord vergeten",
        passwordResetSendAgain: "Stuur een e-mail om mijn wachtwoord opnieuw in te stellen.",
        forgotPasswordConfirmation: "Wachtwoord vergeten? Druk hieronder op 'Bevestigen' om direct een e-mail te ontvangen waarmee je je huidige wachtwoord opnieuw kunt instellen.",
        outstandingEmailReset: "Openstaand wijzigingsverzoek voor e-mail",
        outstandingEmailResetConfirmation: "Je hebt een openstaande bevestigingslink voor een nieuwe e-mail. Deze link is niet langer geldig als je dit verzoek voor een vergeten wachtwoord bevestigt.",
        flash: {
            passwordLink: "Een e-mail is verstuurd naar {{name}} om je wachtwoord opnieuw in te stellen."
        }

    },
    webauthn: {
        setTitle: "Beveiligingssleutel toevoegen",
        updateTitle: "Beveiligingssleutel toevoegen",
        publicKeys: "Je publieke keys",
        noPublicKeys: "Je hebt nog geen keys toegevoegd.",
        nameRequired: "Voordat je een beveiligingssleutel kan toevoegen, moet je deze eerst een naam geven.",
        revoke: "Intrekken",
        addDevice: "Voeg dit apparaat toe",
        info: "Een beveiligingssleutel is een los of ingebouwd apparaat dat strikt persoonlijk van jou is, waarmee je kunt bewijzen dat jij de rechtmatige gebruiker van je eduID-account bent. Nadat je een beveiligingssleutel hebt toegevoegd aan je eduID-account kun je deze gebruiken om mee in te loggen, naast een magische link of wachtwoord.",
        back: "/security",
        setUpdate: "Start",
        updateUpdate: "Voeg deze beveiligingssleutel toe",
        credentialName: "Naam van beveiligingssleutel",
        credentialNamePlaceholder: "bijv. mijn gele Yubikey",
        test: "Test",
        testInfo: "Druk op de <strong>test</strong>knop om een 1 van je beveiligingssleutels te testen. Je wordt doorgestuurd naar het eduID loginscherm.",
        testFlash: "Je hebt met succes de beveligingssleutel getest voor inloggen."
    },
    rememberMe: {
        updated: "Dit apparaat wordt niet langer onthouden",
        forgetMeTitle: "Onthoud dit apparaat",
        info: "Dit apparaat wordt onthouden. Je bent hierdoor automatisch ingelogd met eduID.",
        cancel: "Annuleren",
        update: "Vergeet dit apparaat",
        forgetMeConfirmation: "Weet je zeker dat je dit apparaat niet langer wilt onthouden?",
        forgetMe: "Vergeet dit apparaat"
    },
    footer: {
        privacy: "Privacybeleid",
        terms: "Voorwaarden",
        help: "Help",
        poweredBy: "Aangeboden door"
    },
    modal: {
        cancel: "Annuleren",
        confirm: "Bevestigen"
    },
    format: {
        creationDate: "{{date}} om {{hours}}:{{minutes}}"
    },
    getApp: {
        header: "Download de eduID app",
        info: "Download en installeer <a href=\"https://eduid.nl/help\" target=\"_blank\">de eduID app</a> (uitgegeven door SURF) op je mobiele apparaat.",
        google: "https://play.google.com/apps/testing/nl.eduid",
        apple: "https://testflight.apple.com/join/Ogk1TxKu",
        after: "Als je de eduID app op je telefoon hebt gedownload, kom dan hier terug en klik op volgende.",
        back: "Terug",
        next: "Volgende"
    },
    sms: {
        header: "Controleer je telefoon",
        info: "Voer de zescijferige code in die we naar je telefoon hebben gestuurd om door te gaan.",
        codeIncorrect: "De code is onjuist",
        maxAttemptsPre: "Maximum aantal pogingen bereikt. Klik",
        maxAttemptsPost: "om opnieuw je telefoonnummer in te voeren en een nieuwe code te ontvangen",
        maxAttemptsPostNoReEnter: "om een nieuwe code aan te vragen",
        here: " hier "

    },
    enrollApp: {
        header: "Voltooi de installatie in de eduID app",
        scan: "Scan deze QR-code met je eduID app",
        timeOut: "Sessie timeout",
        timeOutInfoFirst: "Je sessie is verlopen. Klik op deze ",
        timeOutInfoLast: " om het opnieuw te proberen.",
        timeOutInfoLink: "link",
        openEduIDApp: "Open de app op dit apparaat"
    },
    recovery: {
        header: "Een herstelmethode instellen",
        changeHeader: "Verander je herstelmethode",
        info: "Als je de eduID app niet meer kunt gebruiken, bijvoorbeeld bij verlies van je mobiele telefoon, kun je met de herstelmethode de eduID app opnieuw registreren.",
        changeInfo: "Je bent succesvol geauthenticeerd met je eduID app. Je kan nu je herstelmethode voor de eduID app veranderen. LET OP: je huidige herstelmethode komt te vervallen.",
        methods: "De volgende methoden zijn beschikbaar.",
        phoneNumber: "Register hersteltelefoonnummer.",
        phoneNumberInfo: "Je ontvangt een SMS met een verificatiecode.",
        backupCode: "Registreer herstelcode.",
        backupCodeInfo: "Bewaar deze code op een veilige plek.",
        save: "Bewaar de code ergens veilig.",
        active: "Deze code is nu actief en je eduID app is klaar om te gebruiken.",
        copy: "Kopieer de code",
        copied: "Gekopieerd",
        continue: "Mijn code is veilig. Doorgaan",
        leaveConfirmation: "Weet je zeker dat je deze pagina wilt verlaten? Wijzigingen worden niet opgeslagen."
    },
    phoneVerification: {
        header: "Voeg een hersteltelefoonnummer toe",
        info: "Je telefoonnummer wordt gebruikt om weer toegang te krijgen tot je account als je de app ooit kwijtraakt.",
        text: "We sturen je een code om je nummer te verifiëren.",
        verify: "Verifieer dit telefoonnummer",
        placeHolder: "+31 612345678",
        phoneIncorrect: "Verificatiecode is onjuist"
    },
    congrats: {
        header: "Succes",
        info: "Je kunt nu de eduID app gebruiken om snel in te loggen bij diensten die eduID gebruiken.",
        changeInfo: "Je hebt je herstelmethode veranderd.",
        next: "Terug naar instellingen"
    },
    deactivate: {
        titleDelete: "Deactiveer je eduID app",
        info: "Je kunt je eduID app deactiveren als je de app opnieuw wilt installeren of als je een nieuw apparaat hebt.",
        recoveryCode: "Herstelcode",
        recoveryCodeInfo: "Vul de <strong>herstelcode</strong> in die je tijdens de eduID app registratie hebt bewaard.",
        verificationCode: "SMS verificatiecode",
        codeIncorrect: "Verkeerde verificatiecode",
        next: "Volgende",
        deactivateApp: "Deactiveer",
        sendSms: "Druk op volgende om een SMS met een verificatiecode naar je geregistreerde telefoonnummer te sturen.",
        maxAttempts: "Maximum aantal pogingen bereikt. Neem contact op met <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> voor hulp."
    },
    backupCodes: {
        title: "Herstelmethode",
        info: "Je hebt de eduID app geïnstalleerd en geregistreerd. Om je herstelmethode te wijzigen, moet je je eerst authenticeren met de eduID app.",
        phoneNumber: "Mobiel nummer",
        startTiqrAuthentication: "Wijzig",
        code: "Code"
    },
    useApp: {
        header: "Controleer je eduID app",
        info: "We hebben een pushmelding naar je app gestuurd om te verifiëren dat jij het bent die probeert in te loggen.",
        scan: "Scan deze QR-code met je eduID app",
        noNotification: "Geen melding?",
        qrCodeLink: "Maak een QR-code",
        qrCodePostfix: "en scan deze.",
        offline: "Wanneer je apparaat offline is, moet je een ",
        offlineLink: "eenmalige code invoeren.",
        lost: "Je app verloren?",
        lostLink: "Lees op <a href=\"https://eduid.nl/help\" target=\"_blank\">hoe je een nieuwe moet registreren</a>.",
        timeOut: "Sessie timeout",
        timeOutInfoFirst: "Je sessie is verlopen. Klik op deze ",
        timeOutInfoLast: " om het opnieuw te proberen.",
        timeOutInfoLink: "link",
        responseIncorrect: "De code is niet juist.",
        suspendedResult: "De verficatie van je eduID app is mislukt. ",
        accountNotSuspended: "Je kan het opnieuw proberen.",
        accountSuspended: "Je zal {{minutes}} {{plural}} moeten wachten totdat je het opnieuw kan proberen.",
        minutes: "minuten",
        minute: "minuut"
    },
    createFromInstitution: {
        title: "Maak een eduID van je instelling",
        header: "Je staat op het punt een eduID-account aan te maken dat wordt gekoppeld aan je instellingsaccount.",
        alreadyHaveAnEduID: "Heb je al een eduID-account? <a href=\"{{location}}\">Login!</a>",
        info: "Als je verder gaat, wordt je gevraagd om in te loggen bij de instelling die je aan je eduID wilt koppelen. Na een succesvolle login kom je hier terug." ,
        startFlow: "Start registratie",
        welcome: "Je eduID account is aangemaakt",
        welcomeExisting: "Je eduID account is gekoppeld aan de vertrouwde instellingsaccount"
    },
    linkFromInstitution: {
        header: "Hi {{name}}",
        info: "Je bent succesvol ingelogd bij je instelling. Voer nu je persoonlijke email in, dit wordt je eduID email.",
        email: "Je e-mail",
        emailPlaceholder: "e.g. user@gmail.com",
        emailForbidden: "Het aanmaken van een eduID-account met deze email is niet toegestaan, neem contact op met <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> als je denkt dat het e-maildomein geldig is.",
        emailInUse1: "Dit e-mailadres is al in gebruik.",
        emailInUse2: "Probeer een andere, of ",
        emailInUse3: " koppel met dit eduID account.",
        invalidEmail: "Ongeldig e-mailadres",
        institutionDomainNameWarning: "Het lijkt erop dat je een instellings e-mailadres hebt ingevoerd. Houd er rekening mee dat wanneer je niet meer studeert of werkt bij die instelling, je geen toegang meer hebt tot dat e-mail adres.",
        institutionDomainNameWarning2: "We raden je aan om je persoonlijke e-mailadres te gebruiken voor eduID.",
        allowedDomainNamesError: "Domeinnaam {{domain}} niet toegestaan.",
        allowedDomainNamesError2: "eduID is beperkt om alleen te worden gebruikt door toegestane domeinen.",
        agreeWithTerms: "<span>Ik ga akkoord met <a tabindex='-1' href='https://eduid.nl/gebruiksvoorwaarden/' target='_blank'>de voorwaarden.</a> En ik begrijp <a tabindex='-1' href='https://eduid.nl/privacyverklaring/' target='_blank'>de privacyverklaring</a>.</span>",
        requestEduIdButton: "Vraag je eduID aan",
    },
    pollFromInstitution: {
        header: "Open je mailbox!",
        info: "Om in te loggen, klik op de link in de e-mail die we hebben verstuurd naar <strong>{{email}}</strong>.",
        awaiting: "Wachten tot je op de link klikt...",
        openGMail: "Open Gmail.com",
        openOutlook: "Open Outlook.com",
        spam: "Kan je de e-mail niet vinden? Kijk in je spam.",
        loggedIn: "Inloggen geslaagd!",
        loggedInInfo: "Je kan dit tabblad / venster sluiten.",
        timeOutReached: "Timeout!",
        timeOutReachedInfo: "Je magische link is verlopen. Ga terug naar de dienst waar je heen wou en probeer het opnieuw.",
        resend: "E-mail nog steeds niet gevonden?",
        resendLink: " Stuur de e-mail opnieuw.",
        mailResend: "Check je inbox. We hebben je de e-mail met de magische link opnieuw verzonden.",
    },
    login: {
        requestEduId: "Geen eduID?",
        requestEduId2: "Maak het aan!",
        loginEduId: "Login",
        whatis: "Wat is eduID?",
        header: "Login met eduID",
        headerSubTitle: "om door te gaan naar ",
        header2: "Vraag een eduID aan",
        trust: "Vertrouw deze computer",
        loginOptions: "Andere inlogmanieren",
        loginOptionsToolTip: "We bieden drie manieren om in te loggen:</br><ol>" +
            "<li>Je kunt een magische link ontvangen op je e-mailadres.</li>" +
            "<li>Je kunt een wachtwoord gebruiken. Dit dien je eerst in Mijn eduID in te stellen.</li>" +
            "<li>Je kunt een beveiligingssleutel gebruiken. Dit dien je eerst in Mijn eduID in te stellen.</li>" +
            "</ol>",
        email: "Je e-mailadres",
        emailPlaceholder: "bijv. naam@gmail.com",
        passwordPlaceholder: "Wachtwoord",
        familyName: "Achternaam",
        givenName: "Voornaam",
        familyNamePlaceholder: "bijv. Berners-Lee",
        givenNamePlaceholder: "bijv. Tim",
        sendMagicLink: "Mail een magische link",
        loginWebAuthn: "Login in met een beveiligingssleutel",
        usePassword: "typ een wachtwoord",
        usePasswordNoWebAuthn: "Typ een wachtwoord",
        useMagicLink: "Gebruik magische link",
        useMagicLinkNoWebAuthn: "Gebruik magische link.",
        useWebAuth: "Login in met een beveligingssleutel",
        useOr: " of ",
        requestEduIdButton: "Vraag een eduID aan",
        rememberMe: "Ingelogd blijven",
        password: "Je wachtwoord",
        passwordForgotten: "Wachtwoord vergeten of liever een magische link? ",
        passwordForgottenLink: "Ontvang een e-mail om direct in te loggen.",
        login: "Login",
        create: "Aanmaken",
        newTo: "Voor het eerst bij eduID?",
        createAccount: "Maak een account aan.",
        useExistingAccount: "Gebruik een bestaand account",
        invalidEmail: "Ongeldig e-mailadres",
        requiredAttribute: "{{attr}} is verplicht",
        emailInUse1: "Dit e-mailadres is al in gebruik.",
        emailInUse2: "Probeer een andere, of ",
        emailInUse3: " login met dit eduID account.",
        emailForbidden: "Het aanmaken van een eduID-account met deze email is niet toegestaan, neem contact op met <a href=\"mailto:help@eduid.nl\">help@eduid.nl</a> als je denkt dat het e-maildomein geldig is.",
        emailNotFound1: "We konden geen eduID vinden met deze mail.",
        emailNotFound2: "Probeer een andere, of ",
        emailNotFound3: "maak een nieuw eduID account aan.",
        emailOrPasswordIncorrect: "E-mailadres of wachtwoord is niet juist",
        institutionDomainNameWarning: "Het lijkt erop dat je een instellings e-mailadres hebt ingevoerd. Houd er rekening mee dat wanneer je niet meer studeert of werkt bij die instelling, je geen toegang meer hebt tot dat e-mail adres.",
        institutionDomainNameWarning2: "We raden je aan om je persoonlijke e-mailadres te gebruiken voor eduID.",
        allowedDomainNamesError: "Domeinnaam {{domain}} niet toegestaan.",
        allowedDomainNamesError2: "eduID is beperkt om alleen te worden gebruikt door toegestane domeinen.",
        passwordDisclaimer: "Je wachtwoord moet minimaal 15 karakters lang zijn, of minimaal 8 als het een hoofdletter en een getal bevat.",
        alreadyGuestAccount: "Heb je al een eduID?",
        usePasswordLink: "Gebruik toch een wachtwoord",
        useWebAuthnLink: "Of gebruik een beveiligingssleutel",
        agreeWithTerms: "<span>Ik ga akkoord met <a tabindex='-1' href='https://eduid.nl/gebruiksvoorwaarden/' target='_blank'>de voorwaarden.</a> En ik begrijp <a tabindex='-1' href='https://eduid.nl/privacyverklaring/' target='_blank'>de privacyverklaring</a>.</span>",
        next: "Volgende",
        useOtherAccount: "Gebruik een andere login",
        noAppAccess: "Heb je de app niet bij de hand?",
        noMailAccess: "Kun je niet bij je email?",
        forgotPassword: "Wachtwoord vergeten?",
        useAnother: "Gebruik een andere",
        optionsLink: "inlogmethode.",
    },
    options: {
        header: "Hoe wil je inloggen?",
        noLogin: "Kun je nog niet inloggen?",
        learn: "Zie hoe je jouw",
        learnLink: "account kunt herstellen",
        useApp: "Gebruik de <strong>eduID app</strong> om in te loggen met je mobiel.",
        useWebAuthn: "Gebruik je <strong>beveiligingssleutel</strong>.",
        useLink: "Ontvang een <strong>magische link</strong> in je inbox.",
        usePassword: "Gebruik <strong>een wachtwoord</strong>.",
    },
    magicLink: {
        header: "Open je mailbox!",
        info: "Om in te loggen, klik op de link in de e-mail die we hebben verstuurd naar <strong>{{email}}</strong>.",
        awaiting: "Wachten tot je op de link klikt...",
        openGMail: "Open Gmail.com",
        openOutlook: "Open Outlook.com",
        spam: "Kan je de e-mail niet vinden? Kijk in je spam.",
        loggedIn: "Inloggen geslaagd!",
        loggedInInfo: "Je kan dit tabblad / venster sluiten.",
        timeOutReached: "Timeout!",
        timeOutReachedInfo: "Je magische link is verlopen. Ga terug naar de dienst waar je heen wou en probeer het opnieuw.",
        resend: "E-mail nog steeds niet gevonden?",
        resendLink: " Stuur de e-mail opnieuw.",
        mailResend: "Check je inbox. We hebben je de e-mail met de magische link opnieuw verzonden.",
        loggedInDifferentDevice: "Verificatiecode vereist",
        loggedInDifferentDeviceInInfo: "Je hebt de magische link gebruikt in een andere browser dan van waaruit je de magische link hebt aangevraagd. Als extra veiligheidsmaatregel moet je een verificatiecode invoeren.",
        loggedInDifferentDeviceInInfo2: "We hebben je een extra e-mail gestuurd met de verificatiecode.",
        verificationCodeError: "Verkeerde verificatiecode.",
        verify: "Verifïeer"
    },
    confirm: {
        header: "Gelukt!",
        thanks: "Je eduID is geactiveerd. Ga door naar je bestemming."
    },
    confirmStepup: {
        header: "Gelukt!",
        proceed: "Ga naar {{name}}",
        conditionMet: "Je hebt aan alle voorwaarden voldaan."
    },
    stepup: {
        header: "Nog één ding!",
        info: "Om door te gaan naar <strong>{{name}}</strong>, moet je nog aan de volgende voorwaarde(n) voldoen.",
        link: "Verifieer dit via SURFconext",
        linkExternalValidation: "Verifieer dit via ReadID"
    },
    footer: {
        privacy: "Privacy",
        terms: "Voorwaarden",
        help: "Help",
        poweredBy: "Powered by"
    },
    success: {
        title: "Inloggen bijna geslaagd!",
        info: "Ga terug naar het scherm waar je de magische link hebt aangevraagd en volg de instructies daar op.<br/><br/>Je kunt dit tabblad / venster sluiten."
    },
    expired: {
        title: "Verlopen magische link",
        info: "De magische link die je hebt gebruikt, is verlopen of al een keer gebruikt",
        back: "Ga naar eduid.nl"
    },
    maxAttempt: {
        title: "Maximum aantal pogingen bereikt",
        info: "Je hebt het maximale aantal verificatiepogingen bereikt.",
    },
    notFound: {
        title: "Oeps...",
        title2: "Er is iets fout gegaan (404)."
    },
    webAuthn: {
        info: "Voeg een beveligingssleutel toe",
        browserPrompt: "Klik op de onderstaande knop om een beveligingssleutel toe te voegen aan je eduID-account. Volg daarbij de instructies van je browser op.",
        start: "Start",
        header: "Log in met een beveiligingssleutel",
        explanation: "Er wordt een nieuw venster geopend. Volg de instricties om in te loggen.",
        next: "Log in met een beveiligingssleutel",
        error: "De beveligingssleutel kan niet gebruikt worden."
    },
    useLink: {
        header: "Vraag een magische link aan",
        next: "Email een magische link"
    },
    usePassword: {
        header: "Voer je wachtwoord in",
        passwordIncorrect: "Wachtwoord is onjuist"
    },
    useApp: {
        header: "Controleer je eduID-app",
        info: "We hebben een pushmelding naar je app gestuurd om te verifiëren dat jij het bent die probeert in te loggen.",
        scan: "Scan deze QR-code met je eduID app",
        noNotification: "Geen melding?",
        qrCodeLink: "Maak een QR-code",
        qrCodePostfix: "en scan deze.",
        offline: "Wanneer je apparaat offline is, moet je een ",
        offlineLink: "eenmalige code invoeren.",
        openEduIDApp: "Open de app op dit apparaat",
        lost: "Je app verloren?",
        lostLink: "Lees op <a href=\"https://eduid.nl/help\" target=\"_blank\">hoe je een nieuwe moet registreren</a>.",
        timeOut: "Sessie timeout",
        timeOutInfoFirst: "Je sessie is verlopen. Klik op deze ",
        timeOutInfoLast: " om het opnieuw te proberen.",
        timeOutInfoLink: "link",
        responseIncorrect: "De code is niet juist.",
        suspendedResult: "De verficatie van je eduID app is mislukt. ",
        accountNotSuspended: "Je kan het opnieuw proberen.",
        accountSuspended: "Je zal {{minutes}} {{plural}} moeten wachten totdat je het opnieuw kan proberen.",
        minutes: "minuten",
        minute: "minuut"
    },
    enrollApp: {
        header: "Voltooi de installatie in de eduID app"
    },
    recovery: {
        header: "Een herstelmethode instellen",
        info: "Als je geen toegang hebt tot eduID met de app of via e-mail, kun je een herstelmethode gebruiken om in te loggen op je eduID-account.",
        methods: "De volgende methoden zijn beschikbaar.",
        phoneNumber: "Voeg een hersteltelefoonnummer toe.",
        phoneNumberInfo: "Je ontvangt een sms met een code.",
        backupCode: "Vraag een herstelcode aan.",
        backupCodeInfo: "De code kan worden gebruikt om in te loggen.",
        save: "Bewaar de code ergens veilig.",
        active: "Deze code is nu actief, maar je kan op elk moment een nieuwe code aanmaken binnen mijn eduID.",
        copy: "Kopieer de code",
        copied: "Gekopieerd",
        continue: "Mijn code is veilig. Doorgaan",
        leaveConfirmation: "Weet je zeker dat je de pagina wilt verlaten? De registratie wordt afgebroken."
    },
    phoneVerification: {
        header: "Voeg een hersteltelefoonnummer toe",
        info: "Je telefoonnummer wordt gebruikt om weer toegang te krijgen tot je account als je de app ooit kwijtraakt.",
        text: "We sturen je een code om je nummer te verifiëren.",
        verify: "Verifieer dit telefoonnummer",
        placeHolder: "+31 612345678",
        phoneIncorrect: "Verificatie code is onjuist"
    },
    congrats: {
        header: "Succes",
        info: "Je kunt nu de eduID app gebruiken om snel in te loggen bij diensten waarvoor je moet inloggen met je eduID.",
        next: "Verder naar {{name}}"
    },
    webAuthnTest: {
        info: "Test een beveligingssleutel",
        browserPrompt: "Klik op de onderstaande knop om een beveligingssleutel te testen. Volg daarbij de instructies van je browser op.",
        start: "Test"
    },
    affiliationMissing: {
        header: "Account is gekoppeld, maar...",
        info: "Je eduID is succesvol gekoppeld, maar de instelling die je hebt gekozen heeft niet de juiste attributen teruggegeven.",
        proceed: "Je kan het nogmaals met een andere instelling proberen of doorgaan naar {{name}}.",
        proceedLink: "Doorgaan",
        retryLink: "Opnieuw proberen"
    },
    eppnAlreadyLinked: {
        header: "Account niet gekoppeld!",
        info: "Je eduID kon niet worden gekoppeld. Het vertrouwde account waarmee je zojuist bent ingelogd, is al aan een ander eduID-account gekoppeld: {{email}}.",
        proceed: "Je kan het nogmaals met een andere instelling proberen of doorgaan naar {{name}}.",
        proceedLink: "Doorgaan",
        retryLink: "Opnieuw proberen"
    },
    validNameMissing: {
        header: "Account is gekoppeld, maar...",
        info: "Je eduID is succesvol gekoppeld, maar de instelling die je hebt gekozen heeft niet de juiste attributen teruggegeven.",
        proceed: "Je kan het nogmaals met een andere instelling proberen of doorgaan naar {{name}}.",
        proceedLink: "Doorgaan",
        retryLink: "Opnieuw proberen"
    },
    stepUpExplanation: {
        linked_institution: "Je eduID-account moet gekoppeld zijn aan een vertrouwde instelling.",
        validate_names: "Je voornaam en achternaam moeten worden geverifieerd door een vertrouwde instelling.",
        affiliation_student: "Je moet aantonen dat je onderwijs volgt door je eduID-account te koppelen aan een vertrouwde instelling."
    },
    stepUpVerification: {
        linked_institution: "Je eduID-account is gekoppeld aan een vertrouwde instelling.",
        validate_names: "Je voornaam en achternaam zijn geverifieerd door een vertrouwde instelling.",
        affiliation_student: "Je hebt aangetoont dat je onderwijs volgt doordat je eduID-account is gekoppeld aan een vertrouwde instelling."
    },
    nudgeApp: {
        new: "J eduID is aangemaakt!",
        header: "Wil je de volgende keer sneller en veiliger inloggen?",
        info: "Installeer de <strong>eduID app</strong> en log veiliger in zonder wachtwoord of het openen van je email. Het kost je maar een minuut.",
        no: "Nee bedankt",
        noLink: "/proceed",
        yes: "Installeer nu",
        yesLink: "/eduid-app"
    },
    getApp: {
        header: "Download de eduID app",
        info: "Download en installeer <a href=\"https://eduid.nl/help\" target=\"_blank\">de eduID app</a> (uitgegeven door SURF) op je mobiele apparaat.",
        google: "https://play.google.com/store/apps/details?id=nl.eduid",
        apple: "https://apps.apple.com/",
        after: "Als je de eduID app op je telefoon hebt gedownload, kom dan hier terug en klik op volgende.",
        back: "Terug",
        next: "Volgende"
    },
    sms: {
        header: "Controleer je telefoon",
        info: "Voer de zescijferige code in die we naar je telefoon hebben gestuurd om door te gaan.",
        codeIncorrect: "De code is onjuist",
        sendSMSAgain: "Nieuwe code",
        maxAttemptsPre: "Maximum aantal pogingen bereikt. Klik",
        maxAttemptsPost: "om een ander telefoonnummer te gebruiken of de verstuur een nieuwe code",
        here: " hier "

    },
    rememberMe: {
        yes: "Ja",
        no: "Nee",
        header: "Ingelogd blijven?",
        info: "Blijf ingelogd op dit apparaat zodat je de volgende keer niet hoeft in te loggen."
    },
    modal: {
        cancel: "Annuleer",
        confirm: "Bevestig",
    },
    appRequired: {
        header: "Login met de eduID app",
        info: "Dienst <strong>{{service}}</strong> heeft een login verzocht met de eduID app om je identiteit te bevestigen.",
        info2: "Download de <strong>eduID-app</strong> en log veilig in zonder wachtwoord of toegang tot je e-mail. Het duurt maar een minuut. Klik op <strong>Doorgaan</strong> voor de volgende stap.",
        cancel: "/cancel",
        no: "Ik weiger",
        yesLink: "/proceed",
        yes: "Doorgaan",
        warning: "Het wordt sterk afgeraden om zonder de eduID-app in te loggen. De dienst {{service}} zal niet je attributen ontvangen.",
        warningTitle: "Download eduID-app",
        confirmLabel: "Download eduID-app",
        cancelLabel: "Ik weiger echt"
    },
    subContent: {
        warningTitle: "Weet je het zeker?",
        warning: "De dienst waarop je inlogt heeft expliciet gevraagd om in te loggen met je eduID app. Als je met een andere methode inlogt, ontvangt deze service je attributen niet.",
        confirmLabel: "Verander login optie",
        cancelLabel: "Dat wist ik niet"
    }
};

///*
////////////////////////////////////////////
// this is for creating the struct hierarchy

var currentObject = ""

console.log("struct LocalizedKey {\n")
console.log(eachRecursive(english))

function eachRecursive(obj)
{
    for (var k in obj)
    {
        if (typeof obj[k] == "object" && obj[k] !== null) {
            currentObject = k
            console.log("}")
            console.log("\tstruct", k.charAt(0).toUpperCase() + k.substring(1), "{\n");
            eachRecursive(obj[k]);
        }
            
        else {
            console.log(`static let ${k} = \"${currentObject}-${k}\"` );
        }
    }
}
///////////////////////////////////////
//*/

/*
////////////////////////////////////
// this is for creating the entire list of key, value pairs

console.log(traverse(english, process))

var currentObject = ""

function process(key,value) 
{
    if (typeof value == "object") {
        currentObject = key
    } else {
        console.log(`"${currentObject}-${key}" = "${value}";`);
    }
    
}

function traverse(o,func) {
    for (var i in o) {
        func.apply(this,[i,o[i]]);  
        if (o[i] !== null && typeof(o[i])=="object") {
            //going one step down in the object tree!!
            traverse(o[i],func);
        }
    }
}

////////////////////////
//*/



