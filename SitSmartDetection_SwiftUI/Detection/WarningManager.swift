//
//  WarningManager.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/7/27.
//

import Foundation
class WarningManager{    
    
    var maxIncorrectCount: Int // Warming if exceed\
    var enable: Bool
    private var incorrectCount: Int = 0
    
    
    init(maxIncorrectCount: Int = 5, enable: Bool = false){
        self.enable = enable
        self.maxIncorrectCount = maxIncorrectCount
    }
    
    func updateResults(results: [ResultData]){
        // 要所有部位都正確才可以
        let isAllCorrect = results.allSatisfy { $0.result == "correct" }
        
        if isAllCorrect{
            resetCount()
        }else{
            self.incorrectCount += 1
        }
        
        // Exceed the max acceptable incorrect times
        if (incorrectCount > maxIncorrectCount){
            if self.enable{
                DispatchQueue.global().async { // call at background
                    SpeechPlayer.shared.speak(speech: .badPosture)
                }
            }
            resetCount()
        }
    }
    
    func resetCount(){
        self.incorrectCount = 0
    }
    
    private func playWarningSound() {
        SystemSoundPlayer.shared.playSound()
    }
    
}
