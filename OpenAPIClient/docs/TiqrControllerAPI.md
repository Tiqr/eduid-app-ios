# TiqrControllerAPI

All URIs are relative to *https://login.test.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deactivateApp**](TiqrControllerAPI.md#deactivateapp) | **POST** /mobile/tiqr/sp/deactivate-app | De-activate the app
[**enrollmentStatus**](TiqrControllerAPI.md#enrollmentstatus) | **GET** /mobile/tiqr/poll-enrollment | Poll enrollment
[**finishEnrollment**](TiqrControllerAPI.md#finishenrollment) | **GET** /mobile/tiqr/sp/finish-enrollment | Finish enrollment
[**generateBackupCodeForSp**](TiqrControllerAPI.md#generatebackupcodeforsp) | **GET** /mobile/tiqr/sp/generate-backup-code | Generate back-up code
[**regenerateBackupCodeForSp**](TiqrControllerAPI.md#regeneratebackupcodeforsp) | **GET** /mobile/tiqr/sp/re-generate-backup-code | Generate new back-up code
[**resendPhoneCodeForSp**](TiqrControllerAPI.md#resendphonecodeforsp) | **POST** /mobile/tiqr/sp/re-send-phone-code | Send new phone code
[**sendDeactivationPhoneCodeForSp**](TiqrControllerAPI.md#senddeactivationphonecodeforsp) | **GET** /mobile/tiqr/sp/send-deactivation-phone-code | Send de-activation code
[**sendPhoneCodeForSp**](TiqrControllerAPI.md#sendphonecodeforsp) | **POST** /mobile/tiqr/sp/send-phone-code | Send phone code
[**spAuthenticationStatus**](TiqrControllerAPI.md#spauthenticationstatus) | **GET** /mobile/tiqr/sp/poll-authentication | Poll authentication
[**spManualResponse**](TiqrControllerAPI.md#spmanualresponse) | **POST** /mobile/tiqr/sp/manual-response | Manual authentication
[**spReverifyPhoneCode**](TiqrControllerAPI.md#spreverifyphonecode) | **POST** /mobile/tiqr/sp/re-verify-phone-code | Verify phone code again
[**spVerifyPhoneCode**](TiqrControllerAPI.md#spverifyphonecode) | **POST** /mobile/tiqr/sp/verify-phone-code | Verify phone code
[**startAuthenticationForSP**](TiqrControllerAPI.md#startauthenticationforsp) | **POST** /mobile/tiqr/sp/start-authentication | Start authentication
[**startEnrollment**](TiqrControllerAPI.md#startenrollment) | **GET** /mobile/tiqr/sp/start-enrollment | Start enrollment


# **deactivateApp**
```swift
    open class func deactivateApp(deactivateRequest: DeactivateRequest, completion: @escaping (_ data: FinishEnrollment?, _ error: Error?) -> Void)
```

De-activate the app

De-activate the eduID app for the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let deactivateRequest = DeactivateRequest(verificationCode: "verificationCode_example") // DeactivateRequest | 

// De-activate the app
TiqrControllerAPI.deactivateApp(deactivateRequest: deactivateRequest) { (response, error) in
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
 **deactivateRequest** | [**DeactivateRequest**](DeactivateRequest.md) |  | 

### Return type

[**FinishEnrollment**](FinishEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enrollmentStatus**
```swift
    open class func enrollmentStatus(enrollmentKey: String, completion: @escaping (_ data: String?, _ error: Error?) -> Void)
```

Poll enrollment

Poll Tiqr enrollment status

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let enrollmentKey = "enrollmentKey_example" // String | 

// Poll enrollment
TiqrControllerAPI.enrollmentStatus(enrollmentKey: enrollmentKey) { (response, error) in
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
 **enrollmentKey** | **String** |  | 

### Return type

**String**

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **finishEnrollment**
```swift
    open class func finishEnrollment(completion: @escaping (_ data: EnrollmentVerificationKey?, _ error: Error?) -> Void)
```

Finish enrollment

Finish Tiqr enrollment for the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Finish enrollment
TiqrControllerAPI.finishEnrollment() { (response, error) in
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

[**EnrollmentVerificationKey**](EnrollmentVerificationKey.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **generateBackupCodeForSp**
```swift
    open class func generateBackupCodeForSp(completion: @escaping (_ data: GeneratedBackupCode?, _ error: Error?) -> Void)
```

Generate back-up code

Generate a back-up code for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Generate back-up code
TiqrControllerAPI.generateBackupCodeForSp() { (response, error) in
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

[**GeneratedBackupCode**](GeneratedBackupCode.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **regenerateBackupCodeForSp**
```swift
    open class func regenerateBackupCodeForSp(completion: @escaping (_ data: GeneratedBackupCode?, _ error: Error?) -> Void)
```

Generate new back-up code

Generate a new back-up code for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Generate new back-up code
TiqrControllerAPI.regenerateBackupCodeForSp() { (response, error) in
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

[**GeneratedBackupCode**](GeneratedBackupCode.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendPhoneCodeForSp**
```swift
    open class func resendPhoneCodeForSp(phoneCode: PhoneCode, completion: @escaping (_ data: FinishEnrollment?, _ error: Error?) -> Void)
```

Send new phone code

Send a new verification code to mobile phone for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let phoneCode = PhoneCode(phoneNumber: "phoneNumber_example") // PhoneCode | 

// Send new phone code
TiqrControllerAPI.resendPhoneCodeForSp(phoneCode: phoneCode) { (response, error) in
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
 **phoneCode** | [**PhoneCode**](PhoneCode.md) |  | 

### Return type

[**FinishEnrollment**](FinishEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendDeactivationPhoneCodeForSp**
```swift
    open class func sendDeactivationPhoneCodeForSp(completion: @escaping (_ data: FinishEnrollment?, _ error: Error?) -> Void)
```

Send de-activation code

Send a de-activation code to the user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Send de-activation code
TiqrControllerAPI.sendDeactivationPhoneCodeForSp() { (response, error) in
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

[**FinishEnrollment**](FinishEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendPhoneCodeForSp**
```swift
    open class func sendPhoneCodeForSp(phoneCode: PhoneCode, completion: @escaping (_ data: FinishEnrollment?, _ error: Error?) -> Void)
```

Send phone code

Send a verification code to mobile phone for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let phoneCode = PhoneCode(phoneNumber: "phoneNumber_example") // PhoneCode | 

// Send phone code
TiqrControllerAPI.sendPhoneCodeForSp(phoneCode: phoneCode) { (response, error) in
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
 **phoneCode** | [**PhoneCode**](PhoneCode.md) |  | 

### Return type

[**FinishEnrollment**](FinishEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spAuthenticationStatus**
```swift
    open class func spAuthenticationStatus(sessionKey: String, completion: @escaping (_ data: PollAuthenticationResult?, _ error: Error?) -> Void)
```

Poll authentication

Poll Tiqr authentication status for current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let sessionKey = "sessionKey_example" // String | Session key of the authentication

// Poll authentication
TiqrControllerAPI.spAuthenticationStatus(sessionKey: sessionKey) { (response, error) in
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
 **sessionKey** | **String** | Session key of the authentication | 

### Return type

[**PollAuthenticationResult**](PollAuthenticationResult.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spManualResponse**
```swift
    open class func spManualResponse(manualResponse: ManualResponse, completion: @escaping (_ data: FinishEnrollment?, _ error: Error?) -> Void)
```

Manual authentication

Manual Tiqr authentication response

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let manualResponse = ManualResponse(sessionKey: "sessionKey_example", response: "response_example") // ManualResponse | 

// Manual authentication
TiqrControllerAPI.spManualResponse(manualResponse: manualResponse) { (response, error) in
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
 **manualResponse** | [**ManualResponse**](ManualResponse.md) |  | 

### Return type

[**FinishEnrollment**](FinishEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spReverifyPhoneCode**
```swift
    open class func spReverifyPhoneCode(phoneVerification: PhoneVerification, completion: @escaping (_ data: VerifyPhoneCode?, _ error: Error?) -> Void)
```

Verify phone code again

Verify verification code again for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let phoneVerification = PhoneVerification(phoneVerification: "phoneVerification_example") // PhoneVerification | 

// Verify phone code again
TiqrControllerAPI.spReverifyPhoneCode(phoneVerification: phoneVerification) { (response, error) in
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
 **phoneVerification** | [**PhoneVerification**](PhoneVerification.md) |  | 

### Return type

[**VerifyPhoneCode**](VerifyPhoneCode.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **spVerifyPhoneCode**
```swift
    open class func spVerifyPhoneCode(phoneVerification: PhoneVerification, completion: @escaping (_ data: VerifyPhoneCode?, _ error: Error?) -> Void)
```

Verify phone code

Verify verification code for a finished authentication

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let phoneVerification = PhoneVerification(phoneVerification: "phoneVerification_example") // PhoneVerification | 

// Verify phone code
TiqrControllerAPI.spVerifyPhoneCode(phoneVerification: phoneVerification) { (response, error) in
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
 **phoneVerification** | [**PhoneVerification**](PhoneVerification.md) |  | 

### Return type

[**VerifyPhoneCode**](VerifyPhoneCode.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startAuthenticationForSP**
```swift
    open class func startAuthenticationForSP(completion: @escaping (_ data: StartAuthentication?, _ error: Error?) -> Void)
```

Start authentication

Start Tiqr authentication for current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Start authentication
TiqrControllerAPI.startAuthenticationForSP() { (response, error) in
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

[**StartAuthentication**](StartAuthentication.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startEnrollment**
```swift
    open class func startEnrollment(completion: @escaping (_ data: StartEnrollment?, _ error: Error?) -> Void)
```

Start enrollment

Start Tiqr enrollment for the current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Start enrollment
TiqrControllerAPI.startEnrollment() { (response, error) in
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

[**StartEnrollment**](StartEnrollment.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

