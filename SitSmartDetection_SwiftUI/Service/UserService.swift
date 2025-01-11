//
//  UserService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/28.
//

import SwiftUI
import Foundation
import Combine

class UserService: ObservableObject {
//    @EnvironmentObject var authManager: AuthManager
    static let shared = UserService()
    private init() {} // avoid creating second instance
    // Store the data
    // 這邊直接拿回傳的資料，但其實可以多一層轉換(dto)，轉換成有用資訊，減少上層需要做的邏輯運算
    @Published var userInfo: UserResponse? = nil
    
    // TBU: 了解各個function的細節語法
    let router = "\(Config.shared.baseURL)/users"
    private var cancellables = Set<AnyCancellable>()

    func fetchUserData(completion: @escaping (Result<UserResponse, AuthError>) -> Void) {
        print("UserService fethcUserData called!")
        // Fetch user data using access token
        // Call completion with .success(user) or .failure(error)
        let endpoint = "\(self.router)/me"
        APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("fetchUserData failed", error.localizedDescription)
                }
            } receiveValue: { (user: UserResponse) in
                self.userInfo = user
            }
            .store(in: &cancellables)
    }

    func createUser(email: String, username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Service's Signup called")
        let endpoint = "\(router)/"
        let url = URL(string: endpoint)!
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
