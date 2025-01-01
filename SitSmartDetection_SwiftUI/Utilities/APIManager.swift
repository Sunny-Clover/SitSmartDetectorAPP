import Foundation
import Combine

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

class APIManager {
    private var cancellables = Set<AnyCancellable>()
    private var refreshTokenSubject = PassthroughSubject<Void, Never>()
    
    private var accessToken: String? {
        return TokenService.shared.retrieveToken(for: .accessToken) //TODO:等新的方法確定後，就把TokenService拿掉，只保留獲取跟刪除keychain的token方式
    }
    private var isRefreshingToken = false
    
    init() {
        setupTokenRefreshSubscriber()
    }
    
    func performRequest<T: Decodable>(endpoint: String, method: HTTPMethod, body: Data? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        guard let token = accessToken else {
            return Fail(error: URLError(.userAuthenticationRequired))
                .eraseToAnyPublisher()
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
            // flatMap是要接續前面的操作，方便程式可讀性？是前面的事情會先做完嗎？還是做完才到這
            .flatMap { [weak self] _ -> AnyPublisher<T, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
                }
                var retryRequest = request
                retryRequest.setValue("Bearer \(self.accessToken ?? "")", forHTTPHeaderField: "Authorization")
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
            return refreshTokenSubject
                .first()
                .setFailureType(to: Error.self) // 將失敗類型設置為 Error
                .eraseToAnyPublisher()
        }
        
        isRefreshingToken = true
        let refreshTokenEndpoint = "\(Config.shared.baseURL)/auth/refresh"
        guard let url = URL(string: refreshTokenEndpoint) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        
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
            }, receiveCompletion: { [weak self] _ in
                self?.isRefreshingToken = false // TODO: Purpose?
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    private func setupTokenRefreshSubscriber() {
        refreshTokenSubject
            .sink(receiveCompletion: { _ in }, receiveValue: { })
            .store(in: &cancellables)
    }
}
