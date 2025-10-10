# InviteControllerAPI

All URIs are relative to *https://login.test2.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**provisionEduid**](InviteControllerAPI.md#provisioneduid) | **POST** /myconext/api/invite/provision-eduid | 


# **provisionEduid**
```swift
    open class func provisionEduid(eduIDProvision: EduIDProvision, completion: @escaping (_ data: EduIDProvision?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let eduIDProvision = EduIDProvision(eduIDValue: "eduIDValue_example", institutionGUID: "institutionGUID_example") // EduIDProvision | 

InviteControllerAPI.provisionEduid(eduIDProvision: eduIDProvision) { (response, error) in
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
 **eduIDProvision** | [**EduIDProvision**](EduIDProvision.md) |  | 

### Return type

[**EduIDProvision**](EduIDProvision.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

