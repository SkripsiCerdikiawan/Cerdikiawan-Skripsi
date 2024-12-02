//
//  VoiceRecordingHelper.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 27/11/24.
//

import Foundation
import AVFoundation

class VoiceRecordingHelper: NSObject, AVAudioPlayerDelegate {
    public static let shared = VoiceRecordingHelper()
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var session: AVAudioSession
    private var recordingURL: URL?
    
    private var completionHandler: (() -> Void)?
    
    override init() {
        self.session = AVAudioSession.sharedInstance()
        super.init()
        
        self.deleteAllRecordingsOnStartup()
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
            audioPlayer?.delegate = self // Ensure the delegate is set
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            debugPrint("Playing sound from \(url.lastPathComponent)")
            
            // Store the completion handler for later use
            self.completionHandler = completion
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
        // Call the completion handler if it exists
        completionHandler?()
        completionHandler = nil // Reset the handler
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
    
    func deleteAllRecordingsOnStartup() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.pathExtension == "wav" {
                    try FileManager.default.removeItem(at: fileURL)
                    debugPrint("Deleted recording: \(fileURL.lastPathComponent)")
                }
            }
        } catch {
            debugPrint("Failed to delete recordings: \(error.localizedDescription)")
        }
    }
    
    func getRecordingData() -> Data? {
        guard let recordingURL = self.recordingURL else {
            debugPrint("No recording available to fetch data from.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: recordingURL)
            debugPrint("Recording data fetched successfully. Size: \(data.count) bytes.")
            return data
        } catch {
            debugPrint("Failed to fetch recording data: \(error.localizedDescription)")
            return nil
        }
    }
}


extension VoiceRecordingHelper {
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}


