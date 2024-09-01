//
//  SigninViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/18.
//

import Foundation
import Combine
import Security

final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false// false(no accessToken in keychain), otherwise yes
    @Published var userInfo: UserResponse?
    
    
    private let userService = UserService()
    
    init(isAuthenticated: Bool = false, userInfo: UserResponse? = nil) {
        self.isAuthenticated = isAuthenticated
        self.userInfo = userInfo
        checkAuthentication()
    }
    
    func checkAuthentication() {
        if let _ = TokenManager.shared.retrieveToken(key: TokenManager.shared.accessTokenKey){
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        }else{
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
     }

     func fetchUserData() {
         print("VM's fetchUserData called!")
         userService.fetchUserData { [weak self] result in
             switch result {
             case .success(let user):
                 self?.handleSuccessfulFetch(user)
             case .failure(let error):
                 // TODO: 還未實作
                 if (error == .Unauthorized){
                     self?.refreshTokenAndFetchUserData()
                 }
//                 self?.handleFetchError(error)
             }
         }
     }

     private func handleSuccessfulFetch(_ user: UserResponse) {
         // Handle successful data fetch, update UI, navigate to MainView
         // Store user data and update UI
         DispatchQueue.main.async {
             self.isAuthenticated = true
             self.userInfo = user // Data Binding automatically update UI
         }
     }

     private func handleFetchError(_ error: AuthError) {
         // TODO: 要加上fetch資料的錯誤處理，像是過期了怎辦
//         if error.isTokenExpired {
//             refreshTokenAndFetchUserData()
//         } else {
//             isAuthenticated = false
//             // Navigate to AuthView
//         }
         
     }

    // TBU
     private func refreshTokenAndFetchUserData() {
         userService.refreshToken { [weak self] result in
             switch result {
             case .success:
                 self?.fetchUserData()  // 重新获取用户数据
             case .failure:
                 
                 self?.isAuthenticated = false
                 // 导航至 AuthView
             }
         }
     }

    func login(username:String, password:String) {
         // Handle user login and fetch user data
        print("AuthVM login called")
        userService.login(username: username, password: password){
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
            self.fetchUserData()
        }

        // TODO: Add additional oper e.g. fetchUserData automatically
//         userService.login() { [weak self] success in
//             if success {
//                 self?.fetchUserData()
//             } else {
//                 self?.isAuthenticated = false
//                 // Handle login failure, possibly show an error
//             }
//         }
     }
    
    func logout(){
        print("AuthVM logout called")
        userService.logout(){
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
    }
}

enum AuthError: Error, Equatable {
    case missingToken
    case Unauthorized
    case tokenExpired
    case other(Error)
    
    static func ==(lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.missingToken, .missingToken),
             (.Unauthorized, .Unauthorized),
             (.tokenExpired, .tokenExpired):
            return true
        case (.other(let lhsError), .other(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}



//    @Published var username: String = ""
//    @Published var password: String = ""
//    @Published var userID: String?
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?

//    private var baseURL:URL = Config.shared.baseURL
//    private var cancellables = Set<AnyCancellable>()
//
//    func signin() {
//        isLoading = true
//        errorMessage = nil
//
//        let tokenURL = URL(string: "\(baseURL)/auth/token")!
//        var tokenRequest = URLRequest(url: tokenURL)
//        tokenRequest.httpMethod = "POST"
//        tokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let tokenBody: [String: Any] = ["username": username, "password": password]
//        tokenRequest.httpBody = try? JSONSerialization.data(withJSONObject: tokenBody)
//
//        // Request for tokens then call callback getUserInfo
//        URLSession.shared.dataTaskPublisher(for: tokenRequest) // return a dataTaskPublisher
//            .tryMap { output in // = dataTaskPublisher.Output, which is the result of the request
//                // convert URLResponse -> HTTPURLResponse, as? is a method to convert type
//                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data // The return data
//            }
//            .decode(type: TokenResponse.self, decoder: JSONDecoder()) // Decode to the specific type
//            .flatMap { tokenResponse -> AnyPublisher<UserResponse, Error> in
//                let mng = TokenManager.shared
//                mng.storeToken(tokenResponse.accessToken, key: mng.accessTokenKey)
//                mng.storeToken(tokenResponse.refreshToken, key: mng.refreshTokenKey)
//                return self.getUserInfo(with: tokenResponse.accessToken) // return a publisher
//            }
//            .receive(on: DispatchQueue.main) // move process to main thread
//            .sink { completion in           // create a subscriber to connect data flow(data from publisher)
//                self.isLoading = false
//                if case .failure(let error) = completion {
//                    self.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { user in // data from flatMap's callback return (UserResponse)
//                self.userID = String(user.userID)
//            }
//            .store(in: &cancellables) // Retain this subscription
//    }
//    // Request for userInfo
//    private func getUserInfo(with token: String) -> AnyPublisher<UserResponse, Error> {
//        let userURL = URL(string: "\(baseURL)/user/me")!
//        var userRequest = URLRequest(url: userURL)
//        userRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        return URLSession.shared.dataTaskPublisher(for: userRequest)
//            .tryMap { output in
//                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .decode(type: UserResponse.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
//
