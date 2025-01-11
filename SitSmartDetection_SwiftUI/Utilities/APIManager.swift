import Foundation
import Combine

enum HTTPMethod: String {
    case GET, POST, PUT, DELET, PATCH
}


class APIManager {
    static let shared = APIManager()
    
    @Published var isAuthenticated: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var refreshTokenSubject = PassthroughSubject<Void, Never>()
    
    private var accessToken: String? {
        //TODO:等新的方法確定後，就把TokenService拿掉，只保留獲取跟刪除keychain的token方式
        return TokenService.shared.retrieveToken(for: .accessToken)
    }
    private var isRefreshingToken = false
    
    
    init() {
        checkAuthentication()
        setupTokenRefreshSubscriber()
    }
    
    // Token must be stored first
    func performRequest<T: Decodable>(endpoint: String, method: HTTPMethod, body: Data? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        guard let token = accessToken else {
            logout()
            return Fail(error: URLError(.userAuthenticationRequired))
                .eraseToAnyPublisher()
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if method == .POST || method == .PUT || method == .PATCH {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                if let response = output.response as? HTTPURLResponse {
                    if !(200...299).contains(response.statusCode) {
                        if response.statusCode == 401 {
                            throw URLError(.userAuthenticationRequired)
                        } else {
                            throw URLError(.badServerResponse)
                        }
                    }
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { [weak self] error -> AnyPublisher<T, Error> in
                if (error as? URLError)?.code == .userAuthenticationRequired {
                    return self?.handleAuthenticationError(request: request) ?? Fail(error: error).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    
    private func handleAuthenticationError<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        return refreshToken()
            // TODO: flatMap是要接續前面的操作，方便程式可讀性？是前面的事情會先做完嗎？還是做完才到這
            .flatMap { [weak self] _ -> AnyPublisher<T, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
                }
                var retryRequest = request
                guard let newAccessToken = self.accessToken else{
                    logout() // 另一種方式，設計 @escape: completion 做 Refresh失敗->登出
                    return Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
                }
                retryRequest.setValue("Bearer \(newAccessToken)", forHTTPHeaderField: "Authorization")
                return URLSession.shared.dataTaskPublisher(for: retryRequest)
                    .tryMap { output -> Data in
                        if let response = output.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                            throw URLError(.badServerResponse)
                        }
                        return output.data
                    }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func refreshToken() -> AnyPublisher<Void, Error> {
        guard !isRefreshingToken else {
            // 如果已經在refresh了，回傳refresh的publisher給在等待refresh的sub訂閱
            // 當完成refresh的時候，會一次通知所有正在等refresh的sub
            return refreshTokenSubject
                .first()
                .setFailureType(to: Error.self) // 將失敗類型設置為 Error
                .eraseToAnyPublisher()
        }
        
        isRefreshingToken = true
        let refreshTokenEndpoint = "\(Config.shared.baseURL)/auth/refresh"
        
        guard let refreshToken = TokenService.shared.retrieveToken(for: .refreshToken), let url = URL(string: refreshTokenEndpoint) else{
            isRefreshingToken = false
            logout() // 無效refreshToken，登出
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        let bodyDict = ["refresh_token": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> TokenResponse in
                if let response = output.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw URLError(.badServerResponse) //這邊可能就是RefreshToken也過期了
                }
                return try JSONDecoder().decode(TokenResponse.self, from: output.data)
            }
            .handleEvents(receiveOutput: { [weak self] response in
                TokenService.shared.storeToken(response.accessToken, for: .accessToken)
                TokenService.shared.storeToken(response.accessToken, for: .refreshToken)
                self?.isRefreshingToken = false
                self?.refreshTokenSubject.send(()) // issue this msg to waiting reqs
            }, receiveCompletion: { [weak self] completion in
                self?.isRefreshingToken = false
                if case .failure(_) = completion {
                    self?.logout() // 刷新失敗，登出
                }
            })
            .map { _ in () } //TODO: 語法不太懂
            .eraseToAnyPublisher()
    }
    
    private func setupTokenRefreshSubscriber() {
        refreshTokenSubject
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancellables)
    }
    
    private func checkAuthentication() {
        // 檢查是否有有效的 accessToken
        if let _ = TokenService.shared.retrieveToken(for: .accessToken) {
             isAuthenticated = true
         } else {
             isAuthenticated = false
         }
     }
    func logout(){
        TokenService.shared.deleteToken(){
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        }
    }
    func login(username: String, password: String){
        TokenService.shared.requestToken(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.isAuthenticated = true
                }
            case .failure:
                // refreshToken expire, redirect to AuthView(pleas signin again)
                DispatchQueue.main.async {
                    self?.isAuthenticated = false
                }
            }
        }
    }
}
