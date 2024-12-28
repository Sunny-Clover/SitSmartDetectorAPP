//
//  SystemSoundPlayer.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/7/27.
//

import Foundation
import AVFoundation

class SystemSoundPlayer{
    static let shared = SystemSoundPlayer() // 共用Instance
    private var soundID: SystemSoundID
    
    // implement if needed to initialize the soundID
    private init(systemSoundID: SystemSoundID = 1000) { // Default 0
        self.soundID = systemSoundID
    }
    
//    private init(soundName: String) { // 指定本地資源包中的音效
//        // TODO: overloading initializer of pointed sound source name
//        
//    }
    
    /// 從本地資源包中，指定要播的音效
    func playSound(soundName: String){
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        } else {
            print("Sound file not found")
        }
    }
    
    /// 從預設或初始的systemSound播放系統音效
    func playSound() {
        AudioServicesPlaySystemSound(soundID)
    }
}
