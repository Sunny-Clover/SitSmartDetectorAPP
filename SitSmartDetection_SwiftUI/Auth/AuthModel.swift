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
