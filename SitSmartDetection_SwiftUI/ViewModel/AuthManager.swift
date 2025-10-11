import Foundation
import Combine
import Security

struct LoginResponse: Decodable {
    let access_token: String
    let refresh_token: String
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage:String? = nil
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        APIManager.shared.$isAuthenticated
            .sink { [weak self] isAuthenticated in // weak self: 若引用，避免retain cycle，所以要self?避免object被釋放後噴錯
                self?.isAuthenticated = isAuthenticated
            }
            .store(in: &cancellables)
    }
    

    func login(username:String, password:String) {
         // Handle user login and fetch user data
        print("AuthManager login called")
        APIManager.shared.login(username: username, password: password)
     }
    
    func logout() {
        print("AuthManager logout called")
        APIManager.shared.logout()
    }
    
    func signup(email:String, username:String, password:String) {
        print("AuthVM Signup called")
        // TODO: 需確認可行
        UserService.shared.createUser(email: email, username: username, password: password) { result in
            switch result {
            case .success:
                print("Signup successful!")
                self.errorMessage = nil
                // login automatically after signup
                self.login(username: username, password: password)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
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

