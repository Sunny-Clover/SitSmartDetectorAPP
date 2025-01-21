//
//  UserData.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/29.
//

import Foundation
import SwiftData

struct UserResponse: Codable {
    let userID: Int
    let userName: String
    var email: String
    var firstName: String?
    var lastName: String?
    var gender: String
    var photoUrl: String?
    var postureAlertEnable: Bool?
    var postureAlertTime: String?
    var idleAlertEnable: Bool?
    var idleAlertTime: String?
    let allTimeScore: Float
    let totalPredictionCount: Int
    let totalDetectionTime: String
    let pr: Int
    let level: Int
    let levelProgress: Float
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case userName = "UserName"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case gender = "Gender"
        case photoUrl = "PhotoUrl"
        case postureAlertEnable = "PostureAlertEnable"
        case postureAlertTime = "PostureAlertTime"
        case idleAlertEnable = "IdleAlertEnable"
        case idleAlertTime = "IdleAlertTime"
        case allTimeScore = "AllTimeScore"
        case totalPredictionCount = "TotalPredictionCount"
        case totalDetectionTime = "TotalDetectionTime"
        case pr = "PR"
        case level = "Level"
        case levelProgress = "LevelProgress"
    }
}

struct UserUpdate : Codable{
    //var email: String
    var firstName: String?
    var lastName: String?
    var gender: String?
    var photoUrl: String?
    var postureAlertEnable: Bool?
    var postureAlertTime: String?
    var idleAlertEnable: Bool?
    var idleAlertTime: String?
    
    enum CodingKeys: String, CodingKey {
        //case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case gender = "Gender"
        case photoUrl = "PhotoUrl"
        case postureAlertEnable = "PostureAlertEnable"
        case postureAlertTime = "PostureAlertTime"
        case idleAlertEnable = "IdleAlertEnable"
        case idleAlertTime = "IdleAlertTime"
    }
}

struct UploadPhotoResponse: Decodable {
    let message: String
    let filename: String
}
