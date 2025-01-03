//
//  Config.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/8/18.
//

import Foundation

struct Config {
    static let shared = Config()
    
    let accumulateTime:[Int] = [0] + (0..<9).map { 60 * Int(pow(2, Double($0))) }
    let baseURL: URL
    let maxRetryTimes = 5
    
    private init() {
        // 從某個配置文件或環境變量中讀取這些值
        // 這裡我們使用硬編碼的值作為示例
        baseURL = URL(string: "http://192.168.1.119:8000")!
        
    }
}
