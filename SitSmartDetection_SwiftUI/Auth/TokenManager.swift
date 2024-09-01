//
//  TokenManager.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/28.
//

import Foundation
import Combine
import Security


class TokenManager {
    let accessTokenKey = "accessToken"
    let refreshTokenKey = "refreshToken"
    private var baseURL = Config.shared.baseURL

    static let shared = TokenManager()

    func storeToken(_ token: String, key: String) {
        let tokenData = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func retrieveToken(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            print(String(data: data, encoding: .utf8))
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    /// Refresh access token
    func refreshAccessToken() -> AnyPublisher<String, Error> {
        // TBU
        guard let refreshToken = retrieveToken(key: refreshTokenKey) else {
            return Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }

        let refreshURL = URL(string: "\(baseURL)/auth/refresh")!
        var refreshRequest = URLRequest(url: refreshURL)
        refreshRequest.httpMethod = "POST"
        refreshRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["refresh_token": refreshToken]
        refreshRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return URLSession.shared.dataTaskPublisher(for: refreshRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .map { tokenResponse in
                self.storeToken(tokenResponse.accessToken, key: self.accessTokenKey)
                self.storeToken(tokenResponse.refreshToken, key: self.refreshTokenKey)
                return tokenResponse.accessToken
            }
            .eraseToAnyPublisher()
    }
//    
//    func hasValidAccessToken() -> Bool {
//        // Check if access token exists in Keychain and is not expired
//        // Return true if valid, false otherwise
//        return
//    }
}
