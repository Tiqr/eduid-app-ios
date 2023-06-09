# AccountLinkerControllerAPI

All URIs are relative to *https://login.test2.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**startSPLinkAccountFlow**](AccountLinkerControllerAPI.md#startsplinkaccountflow) | **GET** /mobile/api/sp/oidc/link | Start link account flow


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

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

