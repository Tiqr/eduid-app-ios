# RemoteCreationControllerAPI

All URIs are relative to *https://login.test.eduid.nl*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEduID**](RemoteCreationControllerAPI.md#createeduid) | **POST** /api/remote-creation/eduid-create | Create an eduID
[**eduIDForInstitution**](RemoteCreationControllerAPI.md#eduidforinstitution) | **POST** /api/remote-creation/eduid-institution-pseudonym | Return a eduID pseudonym for an institution
[**emailEduIDExists**](RemoteCreationControllerAPI.md#emaileduidexists) | **GET** /api/remote-creation/email-eduid-exists | Does an eduID exists
[**remoteCreation**](RemoteCreationControllerAPI.md#remotecreation) | **GET** /api/remote-creation/eduid-exists | Does an eduID exists
[**updateEduID**](RemoteCreationControllerAPI.md#updateeduid) | **PUT** /api/remote-creation/eduid-update | Update an eduID


# **createEduID**
```swift
    open class func createEduID(newExternalEduID: NewExternalEduID, completion: @escaping (_ data: UpdateExternalEduID?, _ error: Error?) -> Void)
```

Create an eduID

Create an eduID

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let newExternalEduID = NewExternalEduID(email: "email_example", chosenName: "chosenName_example", firstName: "firstName_example", lastNamePrefix: "lastNamePrefix_example", lastName: "lastName_example", dateOfBirth: "dateOfBirth_example", identifier: "identifier_example", verification: "verification_example", brinCode: "brinCode_example") // NewExternalEduID | 

// Create an eduID
RemoteCreationControllerAPI.createEduID(newExternalEduID: newExternalEduID) { (response, error) in
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
 **newExternalEduID** | [**NewExternalEduID**](NewExternalEduID.md) |  | 

### Return type

[**UpdateExternalEduID**](UpdateExternalEduID.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **eduIDForInstitution**
```swift
    open class func eduIDForInstitution(eduIDInstitutionPseudonym: EduIDInstitutionPseudonym, completion: @escaping (_ data: EduIDValue?, _ error: Error?) -> Void)
```

Return a eduID pseudonym for an institution

Return a eduID pseudonym for an institution identified by the BRIN code

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let eduIDInstitutionPseudonym = EduIDInstitutionPseudonym(brinCode: "brinCode_example", eduID: "eduID_example") // EduIDInstitutionPseudonym | 

// Return a eduID pseudonym for an institution
RemoteCreationControllerAPI.eduIDForInstitution(eduIDInstitutionPseudonym: eduIDInstitutionPseudonym) { (response, error) in
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
 **eduIDInstitutionPseudonym** | [**EduIDInstitutionPseudonym**](EduIDInstitutionPseudonym.md) |  | 

### Return type

[**EduIDValue**](EduIDValue.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **emailEduIDExists**
```swift
    open class func emailEduIDExists(email: String, completion: @escaping (_ data: EmailExistsResponse?, _ error: Error?) -> Void)
```

Does an eduID exists

Does an eduID exists with the email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let email = "email_example" // String | 

// Does an eduID exists
RemoteCreationControllerAPI.emailEduIDExists(email: email) { (response, error) in
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
 **email** | **String** |  | 

### Return type

[**EmailExistsResponse**](EmailExistsResponse.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **remoteCreation**
```swift
    open class func remoteCreation(eduID: String, completion: @escaping (_ data: StatusResponse?, _ error: Error?) -> Void)
```

Does an eduID exists

Does an eduID account exists with the eduID identifier

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let eduID = "eduID_example" // String | 

// Does an eduID exists
RemoteCreationControllerAPI.remoteCreation(eduID: eduID) { (response, error) in
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
 **eduID** | **String** |  | 

### Return type

[**StatusResponse**](StatusResponse.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEduID**
```swift
    open class func updateEduID(updateExternalEduID: UpdateExternalEduID, completion: @escaping (_ data: UpdateExternalEduID?, _ error: Error?) -> Void)
```

Update an eduID

Update an eduID

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let updateExternalEduID = UpdateExternalEduID(email: "email_example", chosenName: "chosenName_example", firstName: "firstName_example", lastNamePrefix: "lastNamePrefix_example", lastName: "lastName_example", dateOfBirth: "dateOfBirth_example", identifier: "identifier_example", verification: "verification_example", brinCode: "brinCode_example", eduIDValue: "eduIDValue_example") // UpdateExternalEduID | 

// Update an eduID
RemoteCreationControllerAPI.updateEduID(updateExternalEduID: updateExternalEduID) { (response, error) in
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
 **updateExternalEduID** | [**UpdateExternalEduID**](UpdateExternalEduID.md) |  | 

### Return type

[**UpdateExternalEduID**](UpdateExternalEduID.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

