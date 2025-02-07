//
//  FriendService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/13.
//

import SwiftUI
import Combine

enum RequestAction: String, Codable {
    case Accept
    case Decline
}

class FriendService: ObservableObject {
    static let shared = FriendService()
    private init() {}
    
    @Published var friends: [FriendResponse] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    let router = "\(Config.shared.baseURL)/friends"
    
    func fetchLeaderboard(sortedBy: String) -> AnyPublisher<[LeaderboardData], Error>  {
        print("FriendService fetchLeaderboard called!")

        let endpoint = "\(self.router)/leaderboard?sortBy=\(sortedBy)"
        return APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
    }
    
    func fetchFriendRequests() -> AnyPublisher<[FriendRequestResponse], Error> {
        print("FriendService fetchFriendRequests called!")

        let endpoint = "\(self.router)/requests/received"
        return APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
    }
    
    /// 處理好友請求（接收或拒絕）
    /// - Parameters:
    ///   - request: 待處理的好友請求
    ///   - action: 動作，接收或拒絕
    ///   - completion: 異步完成結果
    func handleFriendRequest(request: FriendRequestResponse,
                             action: RequestAction,
                             completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(self.router)/requests/\(request.requestID)"
        let parameters = ["Action": action.rawValue]
        
        guard let bodyData = try? JSONEncoder().encode(parameters) else {
            completion(.failure(SSDError.encodingFailed))
            return
        }
        
        print("Sending request to \(endpoint) with action \(action.rawValue)")
        
        APIManager.shared.performRequest(endpoint: endpoint, method: .PATCH, body: bodyData)
            .receive(on: DispatchQueue.main)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("Handle Friend Request failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } receiveValue: { (response: SuccessMessage) in
                print("Success: \(response.message)")
                completion(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func searchUser(query: String) -> AnyPublisher<[UserSearchResponse], Error> {
        let endpoint = "\(Config.shared.baseURL)/users/search?q=\(query)"
        
        return APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
    }
    
    func sendFriendRequest(userID: Int, completion: @escaping (Result<Void, Error>) -> Void){
        
        let endpoint = "\(self.router)/requests"
        
        let body = ["ReceiverID" : userID]
        guard let bodyData = try? JSONEncoder().encode(body) else {
            completion(.failure(SSDError.encodingFailed))
            return
        }
        
        APIManager.shared.performRequest(endpoint: endpoint, method: .POST, body: bodyData)
            .receive(on: DispatchQueue.main)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("Send Friend Request failed", error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            } receiveValue: { (msg : SuccessMessage ) in
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            }
            .store(in: &cancellables)
    }
}
