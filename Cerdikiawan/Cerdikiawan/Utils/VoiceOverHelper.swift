//
//  VoiceOverHelper.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 24/11/24.
//

import Foundation
import AVFoundation

class VoiceOverHelper {
    public static let shared: VoiceOverHelper = .init() // Singleton
    
    private let synthesizer: AVSpeechSynthesizer

    private init() {
        self.synthesizer = AVSpeechSynthesizer()
    }

    /// Function to speak a given text in Indonesian language
    func playVoiceOver(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        // Set language to Indonesian (Indonesia)
        utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
        
        // Optionally, you can control the speed and pitch of the voice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // You can adjust this to change speed
        utterance.pitchMultiplier = 1.0 // You can change this to adjust the pitch
        
        synthesizer.speak(utterance)
    }
    
    /// Stop speaking
    func stopVoiceOver() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
