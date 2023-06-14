//
//  MyAccountViewModel.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 14..
//

import Foundation
import OpenAPIClient

class MyAccountViewModel {
    
    let personalInfo: UserResponse
    
    init(personalInfo: UserResponse) {
        self.personalInfo = personalInfo
    }
    
    func downloadData() async throws  -> URL {
        let bodyData = try await UserControllerAPI.personalWithRequestBuilder().execute().bodyData!
        let convertedString = try convertDataToJson(data: bodyData)
        return try writeStringToDataFile(convertedString)
    }
    
    func convertDataToJson(data: Data) throws -> String {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        let prettyJSON = String(data: data, encoding: .utf8)
        return prettyJSON!
    }
    
    func writeStringToDataFile(_ string: String) throws -> URL {
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(generateDataFilename())
        try string.write(to: tmpURL, atomically: true, encoding: .utf8)
        return tmpURL
    }
    
    func generateDataFilename() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timestamp = dateFormatter.string(from: Date())
        return "eduid_my_data_\(timestamp).json"
    }
}
