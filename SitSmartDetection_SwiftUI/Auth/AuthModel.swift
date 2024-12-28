//
//  AuthModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/18.
//

import Foundation

struct SuccessMessage: Codable {
    let message: String
}

struct UserCreate: Codable {
    let email: String
    let userName: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case userName = "UserName"
        case password = "Password"
    }
}

struct UserResponse: Codable {
    let userID: Int
    let userName: String
    let email: String
    let firstName: String?
    let lastName: String?
    let gender: String?
    let photoUrl: String?
    let instantPostureAlertEnable: Bool
    let postureAlertDelayTime: String?
    let idleAlertEnable: Bool
    let idleAlertDelayTime: String?
    let averageScore: Float?
    let totalTime: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case userName = "UserName"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case gender = "Gender"
        case photoUrl = "PhotoUrl"
        case instantPostureAlertEnable = "InstantPostureAlertEnable"
        case postureAlertDelayTime = "PostureAlertDelayTime"
        case idleAlertEnable = "IdleAlertEnable"
        case idleAlertDelayTime = "IdleAlertDelayTime"
        case averageScore = "AverageScore"
        case totalTime = "TotalTime"
    }
}

struct FriendRequestCreate: Codable {
    let receiverID: Int
    
    enum CodingKeys: String, CodingKey {
        case receiverID = "ReceiverID"
    }
}

struct FriendRequestResponse: Codable {
    let requestID: Int
    let senderID: Int
    let senderUserName: String
    let receiverID: Int
    let receiverUserName: String
    let status: String
    let requestDate: String
    
    enum CodingKeys: String, CodingKey {
        case requestID = "RequestID"
        case senderID = "SenderID"
        case senderUserName = "SenderUserName"
        case receiverID = "ReceiverID"
        case receiverUserName = "ReceiverUserName"
        case status = "Status"
        case requestDate = "RequestDate"
    }
}

struct FriendRequestAction: Codable {
    let action: String
    
    enum CodingKeys: String, CodingKey {
        case action = "Action"
    }
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
