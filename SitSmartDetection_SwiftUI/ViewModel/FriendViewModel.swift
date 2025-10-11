//
//  FriendViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/12.
//
import SwiftUI
import Combine
class FriendViewModel: ObservableObject {
//    @Published var friendsDTO: [FriendDTO] = []
    
    @Published var myData: LeaderboardData? = nil
    @Published var friendsData: [LeaderboardData] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchLeaderboard(for option: Int) {
        let sortBy = option == 0 ? "level" : "score"
        FriendService.shared.fetchLeaderboard(sortedBy: sortBy)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching leaderboard: \(error)")
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    // 假設當前用戶的 ID 可以通過 APIManager.shared 或其他方式獲取
                    let currentUserID = UserService.shared.userInfo?.userID
                    
                    // 將自己與好友數據分開
                    self.myData = response.first(where: { $0.userID == currentUserID })
                    self.friendsData = response.filter { $0.userID != currentUserID }
                }
            )
            .store(in: &cancellables)
        }
}
