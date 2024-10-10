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
    @Published var hasToken: Bool = false// false(no accessToken in keychain), otherwise yes
//    @Published var userInfo: UserResponse?
    
    private let tokenService = TokenService()
    
    
    init(hasToken: Bool = false) {
        self.hasToken = hasToken
//        self.userInfo = userInfo
        checkAuthentication()
    }
    
    func checkAuthentication() {
        DispatchQueue.main.async {
            self.hasToken = self.tokenService.hasToken()
        }
     }

//    // TBU
//     private func refreshTokenAndFetchUserData() {
//         UserService.shared.refreshToken { [weak self] result in
//             switch result {
//             case .success:
//                 self?.fetchUserData()  // 帶新的token fetch user data
//             case .failure:
//                 // refreshToken expire, redirect to AuthView(pleas signin again)
//                 self?.isAuthenticated = false
//             }
//         }
//     }

    func login(username:String, password:String) {
         // Handle user login and fetch user data
        print("AuthVM login called")
        tokenService.requestToken(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.hasToken = true
                }
            case .failure:
                // refreshToken expire, redirect to AuthView(pleas signin again)
                DispatchQueue.main.async {
                    self?.hasToken = false
                }
            }
        }
     }
    
    func logout() {
        print("AuthVM logout called")
        tokenService.deleteToken(){
            DispatchQueue.main.async {
                self.hasToken = false
            }
        }
    }
    
    func signup(email:String, username:String, password:String) {
        print("AuthVM Signup called")
        UserService.shared.createUser(email: email, username: username, password: password) { result in
            switch result {
            case .success:
                print("Signup successful!")
                self.login(username: username, password: password)
                // Navigate to the next screen or update the UI
            case .failure(let error):
                print("Signup failed: \(error.localizedDescription)")
                // Show an error message to the user
                // TODO: 加上錯誤訊息，View要接錯誤
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

