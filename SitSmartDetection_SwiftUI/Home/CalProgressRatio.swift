//
//  CalProgressRatio.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/22.
//

import SwiftUI

var tmpBodyPartsTime = [400, 200, 50, 100, 460]
var timeStandard = [100, 300, 500]
var completedBadges: [String] = []
var progressRatioList: [[Double]] = Array(repeating: Array(repeating: 0.0, count: timeStandard.count), count: tmpBodyPartsTime.count)
var achievedPartsStages: [String: String] = [:]
var colors: [Color] = [
        Color(red: 121/255, green: 180/255, blue: 115/255),
        Color(red: 33/255, green: 118/255, blue: 174/255),
        Color(red: 130/255, green: 76/255, blue: 113/255)
    ]

let parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
let stages = ["Starter", "Explorer", "Master"]

func calculateProgress(partTime: Int, index: Int) -> Double {
    switch index {
    case 0: // Starter
        return min(Double(partTime) / Double(timeStandard[0]), 1.0)
    case 1: // Explorer
        return min(max(Double(partTime - timeStandard[0]) / Double(timeStandard[1] - timeStandard[0]), 0.0), 1.0)
    case 2: // Master
        return min(max(Double(partTime - timeStandard[1]) / Double(timeStandard[2] - timeStandard[1]), 0.0), 1.0)
    default:
        return 0.0
    }
}

func calProgressRatio() {
    for Pindex in 0..<tmpBodyPartsTime.count {
        for index in 0..<timeStandard.count {
            let progressRatio = calculateProgress(partTime: tmpBodyPartsTime[Pindex], index: index)
            progressRatioList[Pindex][index] = progressRatio
            
            if progressRatio == 1.0 {
                let achievedPart = parts[Pindex]
                let achievedStage = stages[index]
                
                // 更新該部位獲得的最高階段
                if let currentStage = achievedPartsStages[achievedPart] {
                    let currentStageIndex = stages.firstIndex(of: currentStage)!
                    if index > currentStageIndex {
                        achievedPartsStages[achievedPart] = achievedStage
                    }
                } else {
                    achievedPartsStages[achievedPart] = achievedStage
                }
            }
        }
    }
}

// 建立一個包含執行程式的結構
struct ProgressCalculator {
    static func run() {
        calProgressRatio()

        // 輸出結果檢查
        print(progressRatioList)
        print("Achieved Parts and Stages: \(achievedPartsStages)")
    }
}
