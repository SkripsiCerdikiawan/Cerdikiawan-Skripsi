//
//  VoiceRecordingHelper.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 27/11/24.
//

import Foundation
import AVFoundation

class VoiceRecordingHelper: NSObject, AVAudioPlayerDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var session: AVAudioSession
    private var recordingURL: URL?
    
    override init() {
        self.session = AVAudioSession.sharedInstance()
        super.init()
    }
    
    func getRecordingURL() -> URL? {
        return recordingURL
    }
    
    func startRecording() {
        let options: AVAudioSession.CategoryOptions = [
            .defaultToSpeaker,
            .duckOthers,
            .interruptSpokenAudioAndMixWithOthers
        ]
        
        do {
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: options)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            debugPrint("Cannot setup recording: \(error.localizedDescription)")
            return
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("recording.wav")
        recordingURL = fileName
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            debugPrint("Recording started at \(fileName)")
        } catch {
            debugPrint("Failed to setup recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        guard let recorder = audioRecorder else {
            debugPrint("No recording in progress to stop.")
            return
        }
        recorder.stop()
        
        do {
            try session.setActive(false)
        } catch {
            debugPrint("Failed to deactivate session: \(error.localizedDescription)")
        }
    }
    
    func playSoundFromFile(url: URL, completion: (() -> Void)? = nil) {
        do {
            if let player = audioPlayer, player.isPlaying {
                player.stop()
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            debugPrint("Playing sound from \(url.lastPathComponent)")
        } catch {
            debugPrint("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            debugPrint("Sound playback stopped.")
        } else {
            debugPrint("No sound is currently playing.")
        }
    }
    
    // AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("Sound finished playing.")
        player.stop()
    }
    
    func deleteLastRecording() {
        guard let recordingURL = recordingURL else {
            debugPrint("No recording to delete.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: recordingURL)
            debugPrint("Recording deleted: \(recordingURL.lastPathComponent)")
            self.recordingURL = nil
        } catch {
            debugPrint("Failed to delete recording: \(error.localizedDescription)")
        }
    }
}


