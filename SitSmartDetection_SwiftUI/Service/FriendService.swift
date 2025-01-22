//
//  FriendService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/13.
//

import SwiftUI
import Combine

class FriendService: ObservableObject {
    static let shared = FriendService()
    private init() {}
    
    @Published var friends: [FriendResponse] = []
    
    let router = "\(Config.shared.baseURL)/friends"
    
    func fetchLeaderboard(sortedBy: String) -> AnyPublisher<[LeaderboardData], Error>  {
        print("FriendService fetchLeaderboard called!")

        let endpoint = "\(self.router)/leaderboard?sortBy=\(sortedBy)"
        return APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
    }
}
