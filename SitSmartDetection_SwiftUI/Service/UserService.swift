//
//  UserService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/28.
//

import Foundation
import Combine

class UserService {
    // TBU: 了解各個function的細節語法
    
    let baseURL = Config.shared.baseURL
    let mng = TokenManager.shared
    
    private var cancellables = Set<AnyCancellable>() // TBU:
    
//    func hasValidAccessToken() -> Bool {
//        // Check if access token exists in Keychain and is not expired
//        // Return true if valid, false otherwise
//    }

    func fetchUserData(completion: @escaping (Result<UserResponse, AuthError>) -> Void) {
        print("UserService fethcUserData called!")
        // Fetch user data using access token
        // Call completion with .success(user) or .failure(error)
        guard let accessToken = mng.retrieveToken(key: mng.accessTokenKey) else {
            completion(.failure(.missingToken))
            return
        }
//        print("fetch UserData with accessToken=\(accessToken)")
        let userURL = URL(string: "\(baseURL)/users/me")!
        var userRequest = URLRequest(url: userURL)
        userRequest.httpMethod = "GET"
        userRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: userRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                // 檢查 token 是否過期
                if response.statusCode == 401 {
                    completion(.failure(.Unauthorized))
                }
                return output.data
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .sink { completionResult in
                if case .failure(let error) = completionResult {
                    if let authError = error as? AuthError {
                        completion(.failure(authError))
                    } else {
                        completion(.failure(.other(error)))
                    }
                }
            } receiveValue: { user in
                completion(.success(user))
            }
            .store(in: &cancellables)
    }

    func refreshToken(completion: @escaping (Result<Void, AuthError>) -> Void) {
        // Refresh access token using refresh token
        // Call completion with .success if successful, .failure if failed
        guard let refreshToken = mng.retrieveToken(key: mng.refreshTokenKey) else {
            completion(.failure(.missingToken))
            return
        }
        print("Service's refreshToken called")
//        print("\(refreshToken)")
        let payload = RefreshTokenRequest(refreshToken: refreshToken)
        let refreshTokenURL = URL(string: "\(baseURL)/auth/refresh")!
        var req = URLRequest(url: refreshTokenURL)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type") // Fix 422 Unprocessable Entity Problem
//        req.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
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
                    self.mng.storeToken(tokenResponse.accessToken, key: self.mng.accessTokenKey)
                    self.mng.storeToken(tokenResponse.refreshToken, key: self.mng.refreshTokenKey)
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(.other(error)))
                }
            } else if httpResponse.statusCode == 401 {
                completion(.failure(.Unauthorized))
            } else{
                completion(.failure(.other(URLError(.badServerResponse))))
            }
        }.resume() // TBU
    }

    /// Request for the tokens
    /// TBU
    func login(username: String, password: String, completion: @escaping () -> Void) {
        // Perform login and save tokens to Keychain
        // Call completion with true if login successful, false otherwise
        print("Login called")
        let tokenURL = URL(string: "\(baseURL)/auth/token")!
        var tokenRequest = URLRequest(url: tokenURL)
        tokenRequest.httpMethod = "POST"
        tokenRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
//        let tokenBody: [String: Any] = ["username": username, "password": password]
//        tokenRequest.httpBody = try? JSONSerialization.data(withJSONObject: tokenBody)
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
//                print("UserService's login's tokenResponse \(tokenResponse)")
                TokenManager.shared.storeToken(tokenResponse.accessToken, key: TokenManager.shared.accessTokenKey)
                TokenManager.shared.storeToken(tokenResponse.refreshToken, key: TokenManager.shared.refreshTokenKey)
                // Call the completion block after successful login
                completion()
            }
            .store(in: &cancellables) // Retain this subscription
    }
    
    func logout(completion: @escaping () -> Void){
        // remove token
        TokenManager.shared.deleteToken(key: TokenManager.shared.accessTokenKey)
        TokenManager.shared.deleteToken(key: TokenManager.shared.refreshTokenKey)
        completion()
    }
}


//class UserService {
//    @AppStorage("accessToken") var accessToken: String = ""
//    @AppStorage("refreshToken") var refreshToken: String = ""
//
//    func fetchUserData(completion: @escaping (Result<UserResponse, AuthError>) -> Void) {
//        guard !accessToken.isEmpty else {
//            completion(.failure(.noToken))
//            return
//        }
//
//        // 發送請求至 /user/me 獲取使用者資料
//        // 模擬網路請求結果
//        authViewModel.fetchUserData { result in
//            switch result {
//            case .success(let user):
//                completion(.success(user))
//            case .failure(let error):
//                if error.isTokenExpired {
//                    self.refreshAccessToken(completion: completion)
//                } else {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func refreshAccessToken(completion: @escaping (Result<UserResponse, AuthError>) -> Void) {
//        guard !refreshToken.isEmpty else {
//            completion(.failure(.noRefreshToken))
//            return
//        }
//
//        authViewModel.refreshToken { result in
//            switch result {
//            case .success(let newToken):
//                self.accessToken = newToken
//                self.fetchUserData(completion: completion)
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
