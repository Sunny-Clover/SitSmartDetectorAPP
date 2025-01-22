//
//  SSDExtension.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/19.
//

func extractMinutesAndSeconds(from timeString: String) -> (minutes: Int, seconds: Int)? {
    let components = timeString.split(separator: ":")
    guard components.count == 3,
          let minutes = Int(components[1]),
          let seconds = Int(components[2]) else {
        return nil // 返回 nil 表示格式錯誤
    }
    return (minutes, seconds)
}
func formatToTimeString(hours: Int = 0, minutes: Int, seconds: Int) -> String {
    // 格式化為 hh:mm:ss 的字串
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func extractSeconds(from timeString: String) -> Int? {
    let (mins, secs) = extractMinutesAndSeconds(from: timeString) ?? (0, 0)
    return Int(mins*60 + secs)
}
