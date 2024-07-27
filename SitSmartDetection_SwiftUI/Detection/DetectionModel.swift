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
    var result:String? // = "correct" // or "wrong" // TODO: Use boolean type is better
    var postureType:String? // = "neutral"
}
extension ResultData{
    static var fakeCorrectData = ResultData(icon: "backIcon", bodyPartName: "Back", result: "correct", postureType: "neutral")
    static var fakeWrongData = ResultData(icon: "headIcon", bodyPartName: "Head", result: "wrong", postureType: "forward")
}

// SwiftData Model
@Model
final class DetectionRecord {
    var id: UUID
    var startDetectTimeStamp: Date
    var endDetectTimeStamp: Date
    var detectionInterval: TimeInterval
    
    var head: BodyPartScore
    var neck: BodyPartScore
    var shoulder: BodyPartScore
    var body: BodyPartScore
    var feet: BodyPartScore
    var totalCount: Int
    
    init() {
        self.id = UUID()
        self.startDetectTimeStamp = Date()
        self.endDetectTimeStamp = Date()
        self.detectionInterval = 0
        self.head = BodyPartScore(count: ["Bowed": 0, "Neutral": 0, "Tilt Back": 0])
        self.neck = BodyPartScore(count: ["Forward": 0, "Neutral": 0])
        self.shoulder = BodyPartScore(count: ["Hunched": 0, "Neutral": 0, "Shrug": 0])
        self.body = BodyPartScore(count: ["Backward": 0, "Forward": 0, "Neutral": 0])
        self.feet = BodyPartScore(count: ["Ankle-on-knee": 0, "Flat": 0])
        self.totalCount = 0
    }
}
