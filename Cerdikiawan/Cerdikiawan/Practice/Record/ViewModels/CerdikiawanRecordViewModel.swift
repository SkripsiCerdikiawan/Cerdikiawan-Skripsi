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
    private let pageRepository: PageRepository
    
    init(
        story: StoryEntity,
        character: CharacterEntity,
        pageRepository: PageRepository
    ) {
        self.story = story
        self.character = character
        self.voiceRecordHelper = VoiceRecordingHelper.shared
        self.pageRepository = pageRepository
    }
    
    @MainActor
    func setup() async throws {
        self.storySnapshotList = try await getAllSnapshot()
    }
    
    @MainActor
    func getAllSnapshot() async throws -> [String] {
        var storySnapshot: [String] = []
        guard let storyId = UUID(uuidString: story.storyId) else {
            debugPrint("Invalid story Id")
            return []
        }
        
        let pageRequest = PageRequest(storyId: storyId)
        let (pages, pageStatus) = try await pageRepository.fetchPagesById(request: pageRequest)
        
        guard pageStatus == .success, pages.isEmpty == false else {
            debugPrint("Page did not get fetched")
            return []
        }
        
        for page in pages {
            storySnapshot.append(page.pagePicturePath)
        }
        
        return storySnapshot
    }
    
    // MARK: - Business Logic
    func handleRecord() {
        debugPrint("Recording...")
        
        self.voiceRecordHelper.requestMicrophonePermission { granted in
            if granted {
                self.voiceRecordHelper.startRecording()
                self.characterState = .recording
                self.recordState = .recording
            }
        }
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
