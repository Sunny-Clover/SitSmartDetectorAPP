//
//  SpeechPlayer.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/10/1.
//

import AVFoundation

class SpeechPlayer {
    enum Speech: String {
        case sitTooLong = "坐太久了請起身走動休息一下"
        case badPosture = "坐姿不良 請調整姿勢"
    }

    static let shared = SpeechPlayer()
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() { }
    
    func speak(speech: Speech, language: String = "zh-TW", rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
        DispatchQueue.main.async {
            let utterance = AVSpeechUtterance(string: speech.rawValue)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = rate
            self.synthesizer.speak(utterance)
        }
    }
    
    func stopSpeaking() {
        DispatchQueue.main.async {
            self.synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func pauseSpeaking() {
        DispatchQueue.main.async {
            self.synthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    func continueSpeaking() {
        DispatchQueue.main.async {
            self.synthesizer.continueSpeaking()
        }
    }
}
