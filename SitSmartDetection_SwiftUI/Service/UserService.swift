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
    private var cancellables = Set<AnyCancellable>() // TBU:
    private lazy var path: String = {
        return "\(baseURL)/users/"
    }()
//    func hasValidAccessToken() -> Bool {
//        // Check if access token exists in Keychain and is not expired
//        // Return true if valid, false otherwise
//    }

    func fetchUserData(token: String, completion: @escaping (Result<UserResponse, AuthError>) -> Void) {
        print("UserService fethcUserData called!")
        // Fetch user data using access token
        // Call completion with .success(user) or .failure(error)
//        print("fetch UserData with accessToken=\(accessToken)")
        let userURL = URL(string: path)!
        var userRequest = URLRequest(url: userURL)
        userRequest.httpMethod = "GET"
        userRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
            .receive(on: DispatchQueue.main)
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
    
    func createUser(email: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void){ // The callback receive Result para
        //
        print("Service's Signup called")
        let url = URL(string: path)!
        let payload = UserCreate(email: email, userName: username, password: password)
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // encode and set payload
        do {
            let bodyData = try JSONEncoder().encode(payload)
            req.httpBody = bodyData
        } catch {
            completion(.failure(error))
        }
        
        // Perform the HTTP request
        URLSession.shared.dataTask(with: req) { data, response, error in
            // Handle the response
            if let error = error {
                // If an error occurred, pass it to the completion handler
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Check if the response status code is within the 200-299 range (indicating success)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Signup was successful, call the completion handler with success
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                // If the response status code is not successful, create a custom error
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Signup failed with status code \(statusCode)"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume() // Start the network request
        
    }
}
