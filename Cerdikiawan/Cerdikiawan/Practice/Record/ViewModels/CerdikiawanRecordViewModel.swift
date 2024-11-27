//
//  CerdikiawanRecordViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 27/11/24.
//

import Foundation

class CerdikiawanRecordViewModel: ObservableObject {
    let story: StoryEntity
    
    @Published var storySnapshotList: [String] = []
    @Published var recordState: CerdikiawanRecordContainerState = .start
    @Published var isPlaying: Bool = false
    
    @Published var character: CharacterEntity
    @Published var characterState: CerdikiawanRecordDialogueState = .start
    
    let voiceRecordHelper: VoiceRecordingHelper
    
    init(
        story: StoryEntity,
        character: CharacterEntity
    ) {
        self.story = story
        self.character = character
        self.voiceRecordHelper = .init()
    }
    
    func setup(){
        self.storySnapshotList = getAllSnapshot()
    }
    
    // TODO: Replace with Repo
    func getAllSnapshot() -> [String] {
        return [
            "DEBUG_IMAGE", "DEBUG_IMAGE", "DEBUG_IMAGE"
        ]
    }
    
    // MARK: - Business Logic
    func handleRecord() {
        debugPrint("Recording...")
        self.characterState = .recording
        self.recordState = .recording
        
        self.voiceRecordHelper.startRecording()
    }
    
    func handleStopRecord() {
        debugPrint("Stop Recording...")
        self.characterState = .review
        self.recordState = .review
        
        self.voiceRecordHelper.stopRecording()
    }
    
    func handleReplay() {
        debugPrint("Replaying...")
        self.characterState = .replay
        self.isPlaying = true
        
        if let recordingURL = voiceRecordHelper.getRecordingURL() {
            voiceRecordHelper.playSoundFromFile(url: recordingURL) { [weak self] in
                DispatchQueue.main.async {
                    self?.isPlaying = false
                    self?.characterState = .review
                }
            }
            self.isPlaying = true
            self.characterState = .replay
        } else {
            debugPrint("No recording available to replay.")
        }
    }
    
    func handlePause() {
        debugPrint("Pausing...")
        self.characterState = .review
        self.isPlaying = false
        
        self.voiceRecordHelper.stopSound()
    }
    
    func handleRerecord(){
        debugPrint("Rerecord...")
        self.characterState = .start
        self.recordState = .start
        self.isPlaying = false
        
        self.voiceRecordHelper.stopSound()
        self.voiceRecordHelper.deleteLastRecording()
    }
}
