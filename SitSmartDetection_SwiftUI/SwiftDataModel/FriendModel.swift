//
//  FriendModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/13.
//


struct FriendResponse: Codable {
    
}

struct LeaderboardData: Codable, Identifiable {
    var userID: Int
    var userName: String
    var photoUrl: String
    var rank: Int
    var level: Int
    var progress: Float
    var allTimeScore: Float
    
    var id: Int { userID }
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case userName = "UserName"
        case photoUrl = "PhotoUrl"
        case rank = "Rank"
        case level = "Level"
        case progress = "Progress"
        case allTimeScore = "AllTimeScore"
    }
}


