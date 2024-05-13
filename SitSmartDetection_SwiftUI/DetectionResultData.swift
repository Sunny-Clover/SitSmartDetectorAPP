//
//  DetectionResultData.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//

import Foundation

struct ResultData {
    
    var icon:String // = "backIcon"
    var bodyPartName:String // = "Back"
    var result:String // = "correct" // or "wrong"
    var postureType:String // = "neutral"
}
extension ResultData{
    static var fakeCorrectData = ResultData(icon: "backIcon", bodyPartName: "Back", result: "correct", postureType: "neutral")
    static var fakeWrongData = ResultData(icon: "headIcon", bodyPartName: "Head", result: "wrong", postureType: "forward")
}
