//
//  RecordModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/7.
//

import Foundation

struct BodyCreate: Codable {
    var backwardCount: Int = 0
    var forwardCount: Int = 0
    var neutralCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case backwardCount = "BackwardCount"
        case forwardCount = "ForwardCount"
        case neutralCount = "NeutralCount"
    }
}

struct FeetCreate: Codable {
    var ankleOnKneeCount: Int = 0
    var flatCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case ankleOnKneeCount = "AnkleOnKneeCount"
        case flatCount = "FlatCount"
    }
}

struct HeadCreate: Codable {
    var bowedCount: Int = 0
    var neutralCount: Int = 0
    var tiltBackCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case bowedCount = "BowedCount"
        case neutralCount = "NeutralCount"
        case tiltBackCount = "TiltBackCount"
    }
}

struct ShoulderCreate: Codable {
    var hunchedCount: Int = 0
    var neutralCount: Int = 0
    var shrugCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case hunchedCount = "HunchedCount"
        case neutralCount = "NeutralCount"
        case shrugCount = "ShrugCount"
    }
}

struct NeckCreate: Codable {
    var forwardCount: Int = 0
    var neutralCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case forwardCount = "ForwardCount"
        case neutralCount = "NeutralCount"
    }
}

struct RecordCreate: Codable {
    var startTime: String
    var endTime: String
    var totalTime: String
    var totalPredictions: Int
    var body: BodyCreate
    var feet: FeetCreate
    var head: HeadCreate
    var shoulder: ShoulderCreate
    var neck: NeckCreate

    enum CodingKeys: String, CodingKey {
        case startTime = "StartTime"
        case endTime = "EndTime"
        case totalTime = "TotalTime"
        case totalPredictions = "TotalPredictions"
        case body = "Body"
        case feet = "Feet"
        case head = "Head"
        case shoulder = "Shoulder"
        case neck = "Neck"
    }
}

struct RecordResponse: Codable {
    var recordID: Int
    var userID: Int
    var startTime: String
    var endTime: String
    var totalTime: String
    var totalPredictions: Int
    var body: BodyCreate
    var feet: FeetCreate
    var head: HeadCreate
    var shoulder: ShoulderCreate
    var neck: NeckCreate

    enum CodingKeys: String, CodingKey {
        case recordID = "RecordID"
        case userID = "UserID"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case totalTime = "TotalTime"
        case totalPredictions = "TotalPredictions"
        case body = "Body"
        case feet = "Feet"
        case head = "Head"
        case shoulder = "Shoulder"
        case neck = "Neck"
    }
}
