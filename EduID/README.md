#  EduId Expansion Readme

1) How the EduId Expansion Module is set up through Swift Package Manager
2) The basic architecture (MVVM + C)
3) The way a screen is layed out
4) OAUth + redirecting
5) App localization
6) Network Code (OpenAPI Generator)
7) Onboarding Flows


##1) How the EduId Expansion Module is set up through Swift Package Manager

The new EduId app is built as a module inside the tiqr-app-core-ios swift package. To setup a convenient developer environment, check out the eduId repo (https://github.com/Tiqr/eduid-app-ios.git) and add the swift package from the tiqr core (https://github.com/Tiqr/tiqr-app-core-ios.git) as a local package. It will add the dependencies for the tiqr core module (AnyCodable etc...). This way you can run the app while also access the actual code. Would you be working in the repo with the code (tiqr-app-core-ios) you would not be able to run the app, because this repo contains just the Swift package code.

##2) The basic architecture (MVVM + C)

The newly redesinged app is written in UIKit and uses the MVVM + Coordinator pattern. 

Create EduID flow:

in ScreenType.Swift an enumeration named ScreenType hold all the cases of the screens of the create eduId flow. There is a CreateEduIdCoordinator that coordinates the navigation and setting up op view controllers. Every screentype has a nextscreen() method so the order of the screens is defined in Screentype.swift. The view controller talks back to the coordinator by means of a viewControllerDelegate (e.g. protocol CreateEduIdEnterPersonalDataViewControllerDelegate)

Separation between view code and business logic is by means of a view model. Normally, the view controller is initialized with a viewmodel that does things like fetching the data, parsing it etc. View controller call the view model directly e.g. viewModel.getData(). The view models talk back to the view controller by means of closures that ar optional properties living on the view model. The closures are implemented in the init() method of the view controller so they can later be called by the view model. E.g. :

in view controller:
init(viewMode: ViewModel ) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    viewModel.dataReceivedClosure = { [weak self] response in
        self?.setupUI(response: response)
    }
}

in view model:
var dataReceivedClosure: ((UserResponse) -> Void)?

func getData() {
    Task {
        do {
            let response = try await API.me()
            dataReceivedClosure?(response)
    ...
}

Naming:

All view models have the same name as the view controller save that in stead of ..controller it is called ..model e.g. **EnterPersonalDataViewController: UIViewController <-> EnterPersonalDataViewModel: NSObject**. Delegates from the view controller that talk back to the coordinator have the following naming scheme: **EnterPersonalDataViewController** -> **EnterPersonalDataViewControllerDelegate**.

##3) The way a screen is layed out

To add constraints, use TinyConstraints. E.G. view.width(100), stack.width(to: view). Every screen UI is built from a vertical stack view that optionally holds child stack views, and otherwise labels, images etc. If the screen needs it the stack view is nested in a scroll view. usually all views are initialised up front and then the stack view is created using the init(arrangedSubviews: [UIView]) method. There are several subClasses of UIView, UIButton and UIControl for reusable components. 
If a label is used in a stack view, preferrably the label is nested in an UIView and constrained e.g. view.addSubview(label), label.edges(to: view) so resizing the stackview happens automatically.

##4) OAuth + redirecting

The oAuth flow is handled by the AppAuth-iOS Swift package. It is implemented in a singleton class AppAuthController.swift. To start authenticating, a view controller can call the AppAuth controller's authenticate(viewController: UIViewController) method that will go to an external browser since it is set up with an external useragent. Depending on the session it will prompt the user with a magic link or use an existing session.
The access and redirect tokens are stored (TODO: store refresh token in keychain using a libbrary) and the execute method in APIs.swift holds refresh logic and adds the "Bearer <token>" to the Authorization header. This needs to be reinforced.

The app can redirect from a webpage url by means of a custom scheme eduid:// or https:// in case of a predefined path defined in apple-site-association.json that is hosted on all the eduid servers e.g. login.test2.eduid.nl etc. This is achieved by the associated domains capability tab where "applinks:test2.eduid.nl?mode=developer" among others are defined.
Redirects from https have an entry point in func scene(_ scene: UIScene, continue userActivity: NSUserActivity) _
The custom scheme eduid:// is added as a URL type in the info tab. The entry point for custom schemes is also in SceneDelegate.swift in func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) _
 
##5) App localization
The copy texts for the app have been provided as json files. The contents of this json is copied into the translate.js file that is included in this repository. The translate.json does two things:
1) create a struct hierarchy with static strings for each text copy element. e.g. 

struct LocalizableStrings {
    struct OnBoarding {
        static let welcome = "welcome"
    }
}

2) it created to Localizable.strings files (at the moment Dutch and English) that contain the copy strings. e.g.

"welcome" = "Hi there..."

This is implemented using NSLocalizedString(key: LocalizableString.Onboarding.welcome, bundle: .module, comments: "")

##6) Network Code (OpenAPI Generator)

The networking code is generated off a json spec called api-doc.json provided by eduId. The generator can be installed through instructions from the website https://openapi-generator.tech/. An example commandline command is:

% openapi-generator-cli generate -i ~/Desktop/api-docs.json -g swift5 -o /tmp/test --skip-validate-spec --additional-properties=responseAs=AsyncAwait

Be mindfull to update the swift code because in APIs.swift the code is customised and should not be overridden. Only API files in /APIs/ should be overridden as well as the files in /Models/.
To call an endpoint create and async function in the following way:

        Task {
            do {
                let result = try await AccountLinkerControllerAPI.startSPLinkAccountFlow()
                addInstitutionsCompletion?(result)
            } catch {
                print(error)
            }
        }

## 7) Onboarding Flows

A user can be a new user or an existing Tiqr user. New users can use the onboarding to create their account. Existing users that have used the old app should migrate the secret from the keychain to the new app. Existing users without the old app should onboard in a different way that is yet to be cleared out.
