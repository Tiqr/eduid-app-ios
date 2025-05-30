# UserControllerAPI

All URIs are relative to *https://login.test2.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmUpdateEmail**](UserControllerAPI.md#confirmupdateemail) | **GET** /mobile/api/sp/confirm-email | Confirm email change
[**createEduIDAccount**](UserControllerAPI.md#createeduidaccount) | **POST** /mobile/api/idp/create | Create eduID account
[**createEduIDAccountWithVerificationCode**](UserControllerAPI.md#createeduidaccountwithverificationcode) | **POST** /mobile/api/idp/v2/create | Create eduID account with one-time verification code
[**createUserControlCode**](UserControllerAPI.md#createusercontrolcode) | **POST** /mobile/api/sp/control-code | Create verification control code password link
[**deleteUser**](UserControllerAPI.md#deleteuser) | **DELETE** /mobile/api/sp/delete | Delete
[**deleteUserControlCode**](UserControllerAPI.md#deleteusercontrolcode) | **DELETE** /mobile/api/sp/control-code | Delete existing verification control code
[**forgetMe**](UserControllerAPI.md#forgetme) | **DELETE** /mobile/api/sp/forget | Forget me
[**generateEmailCode**](UserControllerAPI.md#generateemailcode) | **PUT** /mobile/api/sp/generate-email-code | Generate email change code
[**generatePasswordCode**](UserControllerAPI.md#generatepasswordcode) | **PUT** /mobile/api/sp/generate-password-code | Generate change password code
[**institutionNames**](UserControllerAPI.md#institutionnames) | **GET** /mobile/api/sp/institution/names | Institution displaynames
[**institutionalDomains**](UserControllerAPI.md#institutionaldomains) | **GET** /mobile/api/sp/create-from-institution/domain/institutional | All institutional domains
[**institutionalDomains1**](UserControllerAPI.md#institutionaldomains1) | **GET** /mobile/api/idp/email/domain/institutional | All institutional domains
[**logout**](UserControllerAPI.md#logout) | **GET** /mobile/api/sp/logout | Logout
[**me**](UserControllerAPI.md#me) | **GET** /mobile/api/sp/me | User details
[**outstandingEmailLinks**](UserControllerAPI.md#outstandingemaillinks) | **GET** /mobile/api/sp/outstanding-email-links | Get all outstanding change-emails-requests
[**personal**](UserControllerAPI.md#personal) | **GET** /mobile/api/sp/personal | Get personal data
[**removeTokens**](UserControllerAPI.md#removetokens) | **PUT** /mobile/api/sp/tokens | Remove user tokens
[**removeUserLinkedAccounts**](UserControllerAPI.md#removeuserlinkedaccounts) | **PUT** /mobile/api/sp/institution | Remove linked account
[**removeUserService**](UserControllerAPI.md#removeuserservice) | **PUT** /mobile/api/sp/service | Remove user service
[**resendCodeMailMobile**](UserControllerAPI.md#resendcodemailmobile) | **GET** /mobile/api/idp/v2/resend_code_request | Re-send the one-time verification code
[**resendSpCodeMail**](UserControllerAPI.md#resendspcodemail) | **GET** /mobile/api/sp/resend-email-code | Resend email change code
[**resendSpCodePassword**](UserControllerAPI.md#resendspcodepassword) | **GET** /mobile/api/sp/resend-password-code | Resend password change code
[**resetPasswordHashValid**](UserControllerAPI.md#resetpasswordhashvalid) | **GET** /mobile/api/sp/password-reset-hash-valid | Validate password hash
[**resetPasswordLink**](UserControllerAPI.md#resetpasswordlink) | **PUT** /mobile/api/sp/reset-password-link | Reset password link
[**tokens**](UserControllerAPI.md#tokens) | **GET** /mobile/api/sp/tokens | Get all OpenID Connect tokens
[**updateEmail**](UserControllerAPI.md#updateemail) | **PUT** /mobile/api/sp/email | Change email
[**updateLinkedAccount**](UserControllerAPI.md#updatelinkedaccount) | **PUT** /mobile/api/sp/prefer-linked-account | Mark linkedAccount as preferred
[**updateUserPassword**](UserControllerAPI.md#updateuserpassword) | **PUT** /mobile/api/sp/update-password | Update password
[**updateUserProfile**](UserControllerAPI.md#updateuserprofile) | **PUT** /mobile/api/sp/update | Change names
[**verifyChangeEmailCode**](UserControllerAPI.md#verifychangeemailcode) | **PUT** /mobile/api/sp/verify-email-code | Verify change email code
[**verifyCodeMobileUser**](UserControllerAPI.md#verifycodemobileuser) | **PUT** /mobile/api/idp/v2/verify_code_request | Validate the one-time verification code
[**verifyPasswordResetCode**](UserControllerAPI.md#verifypasswordresetcode) | **PUT** /mobile/api/sp/verify-password-code | Verify change password code


# **confirmUpdateEmail**
```swift
    open class func confirmUpdateEmail(h: String, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Confirm email change

Confirm the user has entered the correct one-time code or has clicked on the link in the email sent after requesting to change the users email <br/>A confirmation email is sent to notify the user of the security change with a link to the security settings <a href=\"/#\">https://login.{environment}.eduid.nl/client/mobile/security</a>. <br/>If this URL is not properly intercepted by the eduID app, then the browser app redirects to <a href=\"/#\">eduid://client/mobile/security</a> 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let h = "h_example" // String | The hash obtained from the query parameter 'h' in the URL sent to the user in the update-email

// Confirm email change
UserControllerAPI.confirmUpdateEmail(h: h) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **h** | **String** | The hash obtained from the query parameter &#39;h&#39; in the URL sent to the user in the update-email | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createEduIDAccount**
```swift
    open class func createEduIDAccount(createAccount: CreateAccount, inApp: Bool? = nil, completion: @escaping (_ data: StatusResponse?, _ error: Error?) -> Void)
```

Create eduID account

Create an eduID account and sent a verification mail to the user to confirm the ownership of the email. <br/>Link in the validation email is <a href=\"\">https://login.{environment}.eduid.nl/mobile/api/in-app/create-from-mobile-api?h=={{hash}}</a> whichmust be captured by the eduID app webview.<br/>After the account is finalized server-side the user is logged in and the server redirects to <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/created</a><br/>If the URL is not properly intercepted by the eduID app, then the browser app redirects to <a href=\"\">eduid://client/mobile/created?new=true</a>

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let createAccount = CreateAccount(email: "email_example", givenName: "givenName_example", familyName: "familyName_example", relyingPartClientId: "relyingPartClientId_example") // CreateAccount | 
let inApp = true // Bool |  (optional) (default to false)

// Create eduID account
UserControllerAPI.createEduIDAccount(createAccount: createAccount, inApp: inApp) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAccount** | [**CreateAccount**](CreateAccount.md) |  | 
 **inApp** | **Bool** |  | [optional] [default to false]

### Return type

[**StatusResponse**](StatusResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createEduIDAccountWithVerificationCode**
```swift
    open class func createEduIDAccountWithVerificationCode(createAccount: CreateAccount, completion: @escaping (_ data: CreateEduIDResponse?, _ error: Error?) -> Void)
```

Create eduID account with one-time verification code

Create an eduID account and sent a verification mail to the user to confirm the ownership of the email. <br/>There is a one-time verification code in the email.<br/>Together with the hash returned in this endpoint, this code can be verified (and possible resend)

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let createAccount = CreateAccount(email: "email_example", givenName: "givenName_example", familyName: "familyName_example", relyingPartClientId: "relyingPartClientId_example") // CreateAccount | 

// Create eduID account with one-time verification code
UserControllerAPI.createEduIDAccountWithVerificationCode(createAccount: createAccount) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAccount** | [**CreateAccount**](CreateAccount.md) |  | 

### Return type

[**CreateEduIDResponse**](CreateEduIDResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createUserControlCode**
```swift
    open class func createUserControlCode(controlCode: ControlCode, completion: @escaping (_ data: ControlCode?, _ error: Error?) -> Void)
```

Create verification control code password link

Create a verification control code which users can use to prove their identity at the Service Desk. The code is also send by email to the user. The required field are firstName,  lastName and dayOfBirth. There are no input validations, if the user's dayOfBirth can not be parsed, then this is solved in the approval proces in the Serivce Desk 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let controlCode = ControlCode(firstName: "firstName_example", lastName: "lastName_example", dayOfBirth: "dayOfBirth_example", code: "code_example", documentId: "documentId_example", createdAt: 123, userUid: "userUid_example") // ControlCode | 

// Create verification control code password link
UserControllerAPI.createUserControlCode(controlCode: controlCode) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **controlCode** | [**ControlCode**](ControlCode.md) |  | 

### Return type

[**ControlCode**](ControlCode.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUser**
```swift
    open class func deleteUser(completion: @escaping (_ data: StatusResponse?, _ error: Error?) -> Void)
```

Delete

Delete the current logged in user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Delete
UserControllerAPI.deleteUser() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StatusResponse**](StatusResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserControlCode**
```swift
    open class func deleteUserControlCode(completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Delete existing verification control code

Delete an existing verification control code for a user 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Delete existing verification control code
UserControllerAPI.deleteUserControlCode() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **forgetMe**
```swift
    open class func forgetMe(completion: @escaping (_ data: Int64?, _ error: Error?) -> Void)
```

Forget me

Delete the long remember-me login for the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Forget me
UserControllerAPI.forgetMe() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Int64**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateEmailCode**
```swift
    open class func generateEmailCode(updateEmailRequest: UpdateEmailRequest, force: Bool? = nil, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Generate email change code

Request to change the email of the user. We sent a one-time verification code in verification email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateEmailRequest = UpdateEmailRequest(email: "email_example") // UpdateEmailRequest | 
let force = true // Bool |  (optional) (default to false)

// Generate email change code
UserControllerAPI.generateEmailCode(updateEmailRequest: updateEmailRequest, force: force) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateEmailRequest** | [**UpdateEmailRequest**](UpdateEmailRequest.md) |  | 
 **force** | **Bool** |  | [optional] [default to false]

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generatePasswordCode**
```swift
    open class func generatePasswordCode(completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Generate change password code

Sent the user a mail with a one-time code for the user to change his / hers password. 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Generate change password code
UserControllerAPI.generatePasswordCode() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **institutionNames**
```swift
    open class func institutionNames(schacHome: String, completion: @escaping (_ data: IdentityProvider?, _ error: Error?) -> Void)
```

Institution displaynames

Retrieve the displayNames of the Institution by the schac_home value

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let schacHome = "schacHome_example" // String | 

// Institution displaynames
UserControllerAPI.institutionNames(schacHome: schacHome) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **schacHome** | **String** |  | 

### Return type

[**IdentityProvider**](IdentityProvider.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **institutionalDomains**
```swift
    open class func institutionalDomains(completion: @escaping (_ data: [String]?, _ error: Error?) -> Void)
```

All institutional domains

All institutional domains which will generate a warning if a user enters an email at this domain

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// All institutional domains
UserControllerAPI.institutionalDomains() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**[String]**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **institutionalDomains1**
```swift
    open class func institutionalDomains1(completion: @escaping (_ data: [String]?, _ error: Error?) -> Void)
```

All institutional domains

All institutional domains which will generate a warning if a user enters an email at this domain

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// All institutional domains
UserControllerAPI.institutionalDomains1() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**[String]**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
```swift
    open class func logout(completion: @escaping (_ data: StatusResponse?, _ error: Error?) -> Void)
```

Logout

Logout the current logged in user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Logout
UserControllerAPI.logout() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StatusResponse**](StatusResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **me**
```swift
    open class func me(completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

User details

Retrieve the attributes of the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// User details
UserControllerAPI.me() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **outstandingEmailLinks**
```swift
    open class func outstandingEmailLinks(completion: @escaping (_ data: Bool?, _ error: Error?) -> Void)
```

Get all outstanding change-emails-requests

Get all outstanding change-emails-requests for the logged in user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get all outstanding change-emails-requests
UserControllerAPI.outstandingEmailLinks() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Bool**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **personal**
```swift
    open class func personal(completion: @escaping (_ data: User?, _ error: Error?) -> Void)
```

Get personal data

Get personal data for download

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get personal data
UserControllerAPI.personal() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**User**](User.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeTokens**
```swift
    open class func removeTokens(deleteServiceTokens: DeleteServiceTokens, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Remove user tokens

Remove user token for a service

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let deleteServiceTokens = DeleteServiceTokens(tokens: [TokenRepresentation(id: "id_example", type: "type_example")]) // DeleteServiceTokens | 

// Remove user tokens
UserControllerAPI.removeTokens(deleteServiceTokens: deleteServiceTokens) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteServiceTokens** | [**DeleteServiceTokens**](DeleteServiceTokens.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeUserLinkedAccounts**
```swift
    open class func removeUserLinkedAccounts(updateLinkedAccountRequest: UpdateLinkedAccountRequest, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Remove linked account

Remove linked account for a logged in user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateLinkedAccountRequest = UpdateLinkedAccountRequest(eduPersonPrincipalName: "eduPersonPrincipalName_example", subjectId: "subjectId_example", external: false, idpScoping: "idpScoping_example", schacHomeOrganization: "schacHomeOrganization_example") // UpdateLinkedAccountRequest | 

// Remove linked account
UserControllerAPI.removeUserLinkedAccounts(updateLinkedAccountRequest: updateLinkedAccountRequest) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateLinkedAccountRequest** | [**UpdateLinkedAccountRequest**](UpdateLinkedAccountRequest.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeUserService**
```swift
    open class func removeUserService(deleteService: DeleteService, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Remove user service

Remove user service by the eduID value

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let deleteService = DeleteService(serviceProviderEntityId: "serviceProviderEntityId_example", tokens: [TokenRepresentation(id: "id_example", type: "type_example")]) // DeleteService | 

// Remove user service
UserControllerAPI.removeUserService(deleteService: deleteService) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteService** | [**DeleteService**](DeleteService.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendCodeMailMobile**
```swift
    open class func resendCodeMailMobile(hash: String, completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```

Re-send the one-time verification code

Send the one-time verification code to the user, based on the hash<br/>returned in '/idp/v2/create'

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let hash = "hash_example" // String | 

// Re-send the one-time verification code
UserControllerAPI.resendCodeMailMobile(hash: hash) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hash** | **String** |  | 

### Return type

**String**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendSpCodeMail**
```swift
    open class func resendSpCodeMail(completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```

Resend email change code

Resend the one-time verification code in verification email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Resend email change code
UserControllerAPI.resendSpCodeMail() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendSpCodePassword**
```swift
    open class func resendSpCodePassword(completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```

Resend password change code

Resend the one-time verification code in password change email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Resend password change code
UserControllerAPI.resendSpCodePassword() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPasswordHashValid**
```swift
    open class func resetPasswordHashValid(hash: String, completion: @escaping (_ data: Bool?, _ error: Error?) -> Void)
```

Validate password hash

Check if a password change hash is valid and not expired

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let hash = "hash_example" // String | 

// Validate password hash
UserControllerAPI.resetPasswordHashValid(hash: hash) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hash** | **String** |  | 

### Return type

**Bool**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPasswordLink**
```swift
    open class func resetPasswordLink(completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Reset password link

Sent the user a mail with a link for the user to change his / hers password. <br/>Link in the validation email is <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/reset-password?h=={{hash}}</a> if the user already had a password, otherwise <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/add-password?h=={{hash}}</a><br/>If the URL is not properly intercepted by the eduID app, then the browser app redirects to <a href=\"\">eduid://client/mobile/reset-password?h={{hash}}</a>

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Reset password link
UserControllerAPI.resetPasswordLink() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **tokens**
```swift
    open class func tokens(completion: @escaping (_ data: [Token]?, _ error: Error?) -> Void)
```

Get all OpenID Connect tokens

Get all OpenID Connect tokens for the logged in user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get all OpenID Connect tokens
UserControllerAPI.tokens() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**[Token]**](Token.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEmail**
```swift
    open class func updateEmail(updateEmailRequest: UpdateEmailRequest, force: Bool? = nil, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Change email

Request to change the email of the user. The link in the validation email is <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/update-email?h=={{hash}}</a>with an unique 'h' query param which must be used in 'mobile/api/sp/confirm-email' to confirm the update.<br/>If the URL is not properly intercepted by the eduID app, then the browser app redirects to <a href=\"\">eduid://client/mobile/confirm-email?h={{hash}}</a>

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateEmailRequest = UpdateEmailRequest(email: "email_example") // UpdateEmailRequest | 
let force = true // Bool |  (optional) (default to false)

// Change email
UserControllerAPI.updateEmail(updateEmailRequest: updateEmailRequest, force: force) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateEmailRequest** | [**UpdateEmailRequest**](UpdateEmailRequest.md) |  | 
 **force** | **Bool** |  | [optional] [default to false]

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateLinkedAccount**
```swift
    open class func updateLinkedAccount(updateLinkedAccountRequest: UpdateLinkedAccountRequest, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Mark linkedAccount as preferred

Mark linkedAccount as preferred

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateLinkedAccountRequest = UpdateLinkedAccountRequest(eduPersonPrincipalName: "eduPersonPrincipalName_example", subjectId: "subjectId_example", external: false, idpScoping: "idpScoping_example", schacHomeOrganization: "schacHomeOrganization_example") // UpdateLinkedAccountRequest | 

// Mark linkedAccount as preferred
UserControllerAPI.updateLinkedAccount(updateLinkedAccountRequest: updateLinkedAccountRequest) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateLinkedAccountRequest** | [**UpdateLinkedAccountRequest**](UpdateLinkedAccountRequest.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserPassword**
```swift
    open class func updateUserPassword(updateUserSecurityRequest: UpdateUserSecurityRequest, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Update password

Update or delete the user's password using the hash from the 'h' query param in the validation email or the hash returned after the correct one-time code is verified. If 'newPassword' is null / empty than the password is removed. 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateUserSecurityRequest = UpdateUserSecurityRequest(newPassword: "newPassword_example", hash: "hash_example") // UpdateUserSecurityRequest | 

// Update password
UserControllerAPI.updateUserPassword(updateUserSecurityRequest: updateUserSecurityRequest) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateUserSecurityRequest** | [**UpdateUserSecurityRequest**](UpdateUserSecurityRequest.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserProfile**
```swift
    open class func updateUserProfile(updateUserNameRequest: UpdateUserNameRequest, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Change names

Update the givenName, chosenName and / or the familyName of the User

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateUserNameRequest = UpdateUserNameRequest(chosenName: "chosenName_example", givenName: "givenName_example", familyName: "familyName_example") // UpdateUserNameRequest | 

// Change names
UserControllerAPI.updateUserProfile(updateUserNameRequest: updateUserNameRequest) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateUserNameRequest** | [**UpdateUserNameRequest**](UpdateUserNameRequest.md) |  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyChangeEmailCode**
```swift
    open class func verifyChangeEmailCode(verifyOneTimeLoginCode: VerifyOneTimeLoginCode, completion: @escaping (_ data: [String: String]?, _ error: Error?) -> Void)
```

Verify change email code

If the email code is valid, then return the hash to change the email 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let verifyOneTimeLoginCode = VerifyOneTimeLoginCode(code: "code_example", authenticationRequestId: "authenticationRequestId_example", hash: "hash_example") // VerifyOneTimeLoginCode | 

// Verify change email code
UserControllerAPI.verifyChangeEmailCode(verifyOneTimeLoginCode: verifyOneTimeLoginCode) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOneTimeLoginCode** | [**VerifyOneTimeLoginCode**](VerifyOneTimeLoginCode.md) |  | 

### Return type

**[String: String]**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyCodeMobileUser**
```swift
    open class func verifyCodeMobileUser(verifyOneTimeLoginCode: VerifyOneTimeLoginCode, completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```

Validate the one-time verification code

Validate the one-time verification code send to user in the email.<br/>Together with the validation code, also send the hash returned in '/idp/v2/create'<br/>If the response is 201, then finalize with this url: /mobile/api/create-from-mobile-api/in-app/h={hash}

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let verifyOneTimeLoginCode = VerifyOneTimeLoginCode(code: "code_example", authenticationRequestId: "authenticationRequestId_example", hash: "hash_example") // VerifyOneTimeLoginCode | 

// Validate the one-time verification code
UserControllerAPI.verifyCodeMobileUser(verifyOneTimeLoginCode: verifyOneTimeLoginCode) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOneTimeLoginCode** | [**VerifyOneTimeLoginCode**](VerifyOneTimeLoginCode.md) |  | 

### Return type

**String**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyPasswordResetCode**
```swift
    open class func verifyPasswordResetCode(verifyOneTimeLoginCode: VerifyOneTimeLoginCode, completion: @escaping (_ data: [String: String]?, _ error: Error?) -> Void)
```

Verify change password code

If the password code is valid, then return the hash to change the password 

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let verifyOneTimeLoginCode = VerifyOneTimeLoginCode(code: "code_example", authenticationRequestId: "authenticationRequestId_example", hash: "hash_example") // VerifyOneTimeLoginCode | 

// Verify change password code
UserControllerAPI.verifyPasswordResetCode(verifyOneTimeLoginCode: verifyOneTimeLoginCode) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOneTimeLoginCode** | [**VerifyOneTimeLoginCode**](VerifyOneTimeLoginCode.md) |  | 

### Return type

**[String: String]**

### Authorization

[openId](../README.md#openId)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

