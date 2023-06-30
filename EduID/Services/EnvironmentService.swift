//
//  EnvironmentService.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 30..
//

import Foundation
import OpenAPIClient

struct AuthConfig : Decodable {
    let clientId: String
    let redirectUri: String
    let authorizationEndpointUri: String
    let tokenEndpointUri: String
}

struct Environment {
    let baseUrl: String
    let authConfigFilename: String
    let name: String
    
    func getAuthConfig() -> AuthConfig {
        let path = Bundle.main.path(forResource: authConfigFilename, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(AuthConfig.self, from: data)
    }
    
    static let production = Environment(
        baseUrl: "https://login.eduid.nl",
        authConfigFilename: "auth_config",
        name: "Production"
    )

    static let acceptance = Environment(
        baseUrl: "https://login.acc.eduid.nl",
        authConfigFilename: "auth_config_acceptance",
        name: "Acceptance"
    )

    static let test = Environment(
        baseUrl: "https://login.test.eduid.nl",
        authConfigFilename: "auth_config_test",
        name: "Test"
    )

    static let test2 = Environment(
        baseUrl: "https://login.test2.eduid.nl",
        authConfigFilename: "auth_config_test2",
        name: "Test 2"
    )
}

class EnvironmentService {
    
    let environments: [Environment] = [.production, .acceptance, .test, .test2]
    
    var currentEnvironment: Environment
    
    private static var lastEnvironmentKey = "lastEnvironment"
    
    public static let shared = EnvironmentService()
    
    init() {
        let defaultEnvironment: Environment
        if (Bundle.main.infoDictionary?["EnvironmentSwitcherEnabled"] as? String) == "YES" {
            defaultEnvironment = .test
        } else {
            defaultEnvironment = .production
        }
        let lastEnvironmentName = UserDefaults.standard.string(forKey: EnvironmentService.lastEnvironmentKey) ?? defaultEnvironment.name
        currentEnvironment = environments.first(where: { $0.name == lastEnvironmentName }) ?? defaultEnvironment
    }
    
    public func setEnvironment(_ environment: Environment) {
        UserDefaults.standard.setValue(environment.name, forKey: EnvironmentService.lastEnvironmentKey)
        currentEnvironment = environment
        AppAuthController.shared.loadAuthConfig(environment.getAuthConfig())
        OpenAPIClientAPI.basePath = environment.baseUrl
    }
    
}
