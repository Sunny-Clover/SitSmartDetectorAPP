//
//  TokenManager.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/28.
//

import Foundation
import Combine
import Security


class TokenService {
    enum TokenKey: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    private let baseURL = Config.shared.baseURL
    // lazy: 延遲初始化，直到第一次被使用，避免use instance member 'baseURL' within property initializer
    private lazy var router: [String: String] = {
        return [
            "refreshToken": "\(baseURL)/auth/refresh",
            "requestToken": "\(baseURL)/auth/token"
        ]
    }()
    private var cancellables = Set<AnyCancellable>()
    
    func hasToken() -> Bool{
        guard let token = self.retrieveToken(for: .accessToken),
              let refreshToken = self.retrieveToken(for: .refreshToken) else{
            return false
        }
        return true
    }
    
    func storeToken(_ token: String, for key: TokenKey ) {
        let tokenData = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: tokenData
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func deleteToken(for key: TokenKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    func deleteToken(completion: @escaping () -> Void){
        // remove token
        deleteToken(for: .accessToken)
        deleteToken(for: .refreshToken)
        completion()
    }
    
    func retrieveToken(for key: TokenKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
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
    /// Deprecate
    /// TBU: What the usage of this kind of code do
    func refreshAccessToken() -> AnyPublisher<String, Error> {
        // TBU
        guard let refreshToken = retrieveToken(for: .refreshToken) else {
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
                self.storeToken(tokenResponse.accessToken, for: .accessToken)
                self.storeToken(tokenResponse.refreshToken, for: .refreshToken)
                return tokenResponse.accessToken
            }
            .eraseToAnyPublisher()
    }
    
    /// Refresh access token
    /// 請用這個函示刷新令牌
    func refreshToken(completion: @escaping (Result<Void, AuthError>) -> Void) {
        // Refresh access token using refresh token
        // Call completion with .success if successful, .failure if failed
        print("RefreshToken called")
        guard let refreshToken = retrieveToken(for: .refreshToken) else {
            completion(.failure(.missingToken))
            return
        }
        guard let refreshTokenString = router["refreshToken"],
              let refreshTokenURL = URL(string: refreshTokenString) else {
            completion(.failure(.other(URLError(.badURL))))
            return
        }
        let payload = RefreshTokenRequest(refreshToken: refreshToken)
        
        var req = URLRequest(url: refreshTokenURL)
        req.httpMethod = "POST"
        // Fix 422 Unprocessable Entity Problem by using app/json
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let bodyData = try JSONEncoder().encode(payload)
            req.httpBody = bodyData
        } catch {
            completion(.failure(.other(error)))
        }
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(.other(URLError(.badServerResponse))))
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    // Decode TokenResponse from server
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    
                    // saveToken
                    self.storeToken(tokenResponse.accessToken, for: .accessToken)
                    self.storeToken(tokenResponse.refreshToken, for: .refreshToken)
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(.other(error)))
                }
            } else if httpResponse.statusCode == 401 {
                completion(.failure(.Unauthorized))
            } else{
                completion(.failure(.other(URLError(.badServerResponse))))
            }
        }.resume() // Trigger the Task(=Request be sent when resume called)
    }
    
    /// Request for the token
    /// - Parameters:
    ///   - username: Source area of image to be cropped and resized.
    ///   - password: Size to scale the image to(i.e. image size used while training the model).
    ///   - completion: Closure exec after task success or fail
    func requestToken(username: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        // Perform login and save tokens to Keychain
        // Call completion with true if login successful, false otherwise
        
        guard let path = router["requestToken"],
              let tokenURL = URL(string: path) else {
            completion(.failure(.other(URLError(.badURL))))
            return
        }
        var tokenRequest = URLRequest(url: tokenURL)
        tokenRequest.httpMethod = "POST"
        tokenRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "username=\(username)&password=\(password)"
        tokenRequest.httpBody = bodyString.data(using: .utf8)
        
        
        // Request for tokens then call callback getUserInfo
        URLSession.shared.dataTaskPublisher(for: tokenRequest) // return a dataTaskPublisher
            .tryMap { output in // = dataTaskPublisher.Output, which is the result of the request
                // convert URLResponse -> HTTPURLResponse, as? is a method to convert type
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data // The return data
            }
            .decode(type: TokenResponse.self, decoder: JSONDecoder()) // Decode to the specific type
            .sink { completion in   // create a subscriber to connect data flow(data from publisher)
                if case .failure(let error) = completion {
                    //                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { tokenResponse in  // data from sink's callback?? return (tokenResponse)
                //                print("Requested token = \(tokenResponse)")
                self.storeToken(tokenResponse.accessToken, for: .accessToken)
                self.storeToken(tokenResponse.refreshToken, for: .refreshToken)
                // Call the completion block after successful login
                completion(.success(Void()))
            }
            .store(in: &cancellables) // Retain this subscription
    }
}
