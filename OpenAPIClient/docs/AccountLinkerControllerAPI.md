# AccountLinkerControllerAPI

All URIs are relative to *https://login.test.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**issuers**](AccountLinkerControllerAPI.md#issuers) | **GET** /mobile/api/sp/idin/issuers | All verify issuers
[**startSPLinkAccountFlow**](AccountLinkerControllerAPI.md#startsplinkaccountflow) | **GET** /mobile/api/sp/oidc/link | Start link account flow
[**startSPVerifyIDLinkAccountFlow**](AccountLinkerControllerAPI.md#startspverifyidlinkaccountflow) | **GET** /mobile/api/sp/verify/link | Start verify ID flow for signicat from SP flow


# **issuers**
```swift
    open class func issuers(completion: @escaping (_ data: [VerifyIssuer]?, _ error: Error?) -> Void)
```

All verify issuers

All verify issuers to build the select Bank page for ID verificatin

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// All verify issuers
AccountLinkerControllerAPI.issuers() { (response, error) in
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

[**[VerifyIssuer]**](VerifyIssuer.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startSPLinkAccountFlow**
```swift
    open class func startSPLinkAccountFlow(completion: @escaping (_ data: AuthorizationURL?, _ error: Error?) -> Void)
```

Start link account flow

Start the link account flow for the current user.<br/>After the account has been linked the user is redirect to one the following URL's:<ul><li>Success: <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/account-linked</a></li><li>Failure, EPPN already linked: <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/eppn-already-linked?email=jdoe%40example.com</a></li><li>Failure, session expired: <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/expired</a></li></ul>

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Start link account flow
AccountLinkerControllerAPI.startSPLinkAccountFlow() { (response, error) in
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

[**AuthorizationURL**](AuthorizationURL.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startSPVerifyIDLinkAccountFlow**
```swift
    open class func startSPVerifyIDLinkAccountFlow(idpScoping: IdpScoping_startSPVerifyIDLinkAccountFlow, bankId: String? = nil, completion: @escaping (_ data: AuthorizationURL?, _ error: Error?) -> Void)
```

Start verify ID flow for signicat from SP flow

Start the verify ID flow for the current user.<br/>After the account has been linked the user is redirect to one the following URL's:<ul><li>Success: <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/verify-account-linked</a></li><li>Failure, something went wrong: <a href=\"\">https://login.{environment}.eduid.nl/client/mobile/verify-error</a></li></ul>

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let idpScoping = "idpScoping_example" // String | 
let bankId = "bankId_example" // String |  (optional)

// Start verify ID flow for signicat from SP flow
AccountLinkerControllerAPI.startSPVerifyIDLinkAccountFlow(idpScoping: idpScoping, bankId: bankId) { (response, error) in
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
 **idpScoping** | **String** |  | 
 **bankId** | **String** |  | [optional] 

### Return type

[**AuthorizationURL**](AuthorizationURL.md)

### Authorization

[openId](../README.md#openId), [basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

