//
//  HistoryDataModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/6/12.
//

import Foundation
import SwiftData

struct BodyPartScore:Codable, Hashable {
    var count: [String: Int]
    var score: Double
    
    init(count: [String: Int], score: Double = 0) {
        self.count = count
        self.score = score
    }
}

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
