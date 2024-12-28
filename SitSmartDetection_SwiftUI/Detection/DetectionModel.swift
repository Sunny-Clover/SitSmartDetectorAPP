//
//  DetectionModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/7/27.
//

import Foundation
import SwiftData

// Models for display UI

struct BodyPartScore:Codable, Hashable {
    var count: [String: Int]
    var score: Double
    
    init(count: [String: Int], score: Double = 0) {
        self.count = count
        self.score = score
    }
}

struct poseClassfiedResult{
    let category:String
    let prob:Float32
}

struct ResultData: Decodable {
    
    var icon:String // = "backIcon"
    var bodyPartName:String // = "Back"
    var result:String? // = "correct" // or "wrong" // or "ambiguos"
    var postureType:String? // = "neutral" // "ambiguos"
}
extension ResultData{
    static var fakeCorrectData = ResultData(icon: "backIcon", bodyPartName: "Back", result: "correct", postureType: "neutral")
    static var fakeWrongData = ResultData(icon: "headIcon", bodyPartName: "Head", result: "wrong", postureType: "forward")
}

// SwiftData Model
//@Model
final class DetectionRecord {
    var startDetectTimeStamp: Date
    var endDetectTimeStamp: Date
    var detectionInterval: TimeInterval
    
    var head: BodyPartScore
    var neck: BodyPartScore
    var shoulder: BodyPartScore
    var body: BodyPartScore
    var feet: BodyPartScore
    var totalCount: Int
    
    // TODO: 加上 Ambiguous
    init() {
        self.startDetectTimeStamp = Date()
        self.endDetectTimeStamp = Date()
        self.detectionInterval = 0
        self.head = BodyPartScore(count: ["Bowed": 0, "Neutral": 0, "Tilt Back": 0, "Ambiguous": 0])
        self.neck = BodyPartScore(count: ["Forward": 0, "Neutral": 0, "Ambiguous": 0])
        self.shoulder = BodyPartScore(count: ["Hunched": 0, "Neutral": 0, "Shrug": 0, "Ambiguous": 0])
        self.body = BodyPartScore(count: ["Backward": 0, "Forward": 0, "Neutral": 0, "Ambiguous": 0])
        self.feet = BodyPartScore(count: ["Ankle-on-knee": 0, "Flat": 0, "Ambiguous": 0])
        self.totalCount = 0
    }
}

extension DetectionRecord {
    func toRecordCreate() -> RecordCreate {
        // 將時間格式轉換為 String
        let startTime = DateFormatter.apiDateFormatter.string(from: startDetectTimeStamp)
        let endTime = DateFormatter.apiDateFormatter.string(from: endDetectTimeStamp)
        let totalTime = formatTimeInterval(detectionInterval)
        
        // 將 BodyPartScore 的資料轉換為 BodyCreate、FeetCreate 等後端接受的格式
        let bodyCreate = BodyCreate(
            backwardCount: body.count["Backward"] ?? 0,
            forwardCount: body.count["Forward"] ?? 0,
            neutralCount: body.count["Neutral"] ?? 0
        )
        
        let feetCreate = FeetCreate(
            ankleOnKneeCount: feet.count["Ankle-on-knee"] ?? 0,
            flatCount: feet.count["Flat"] ?? 0
        )
        
        let headCreate = HeadCreate(
            bowedCount: head.count["Bowed"] ?? 0,
            neutralCount: head.count["Neutral"] ?? 0,
            tiltBackCount: head.count["Tilt Back"] ?? 0
        )
        
        let shoulderCreate = ShoulderCreate(
            hunchedCount: shoulder.count["Hunched"] ?? 0,
            neutralCount: shoulder.count["Neutral"] ?? 0,
            shrugCount: shoulder.count["Shrug"] ?? 0
        )
        
        let neckCreate = NeckCreate(
            forwardCount: neck.count["Forward"] ?? 0,
            neutralCount: neck.count["Neutral"] ?? 0
        )
        
        // 建立 RecordCreate 物件
        return RecordCreate(
            startTime: startTime,
            endTime: endTime,
            totalTime: totalTime,
            totalPredictions: totalCount,
            body: bodyCreate,
            feet: feetCreate,
            head: headCreate,
            shoulder: shoulderCreate,
            neck: neckCreate
        )
    }
    
    // 格式化 TimeInterval 轉換為 "HH:mm:ss" 的格式
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}

extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
