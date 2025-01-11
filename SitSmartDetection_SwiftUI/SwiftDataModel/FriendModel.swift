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
    var name: String
    var rank: Int
    var level: Int
    var progress: Float
    var allTimeScore: Float
    
    var id: Int { userID }
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case name = "Name"
        case rank = "Rank"
        case level = "Level"
        case progress = "Progress"
        case allTimeScore = "AllTimeScore"
    }
}


