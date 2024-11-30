//
//  CerdikiawanReportDetailViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation
import AVFAudio

class CerdikiawanReportDetailViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var userData: UserEntity?
    @Published var story: ReportStoryEntity
    @Published var currentlyPlayedAttemptId: String?
    @Published var attempts: [AttemptDataEntity] = []
    
    private var attemptRepository: AttemptRepository
    private var recordSoundRepository: RecordSoundStorageRepository
    private var audioPlayer: AVAudioPlayer?
    
    init(story: ReportStoryEntity, attemptRepository: AttemptRepository, recordSoundRepository: RecordSoundStorageRepository) {
        self.story = story
        self.attemptRepository = attemptRepository
        self.recordSoundRepository = recordSoundRepository
    }
    
    @MainActor
    func setup(userData: UserEntity?) async throws {
        self.userData = userData
        attempts = try await fetchAttempts()
    }
    
    @MainActor
    public func fetchAttempts() async throws -> [AttemptDataEntity] {
        var attemptEntities: [AttemptDataEntity] = []
        
        guard let user = userData else {
            debugPrint("User Data not found")
            return []
        }
        
        guard let userId = UUID(uuidString: user.id) else {
            debugPrint("Invalid UserId")
            return []
        }
        
        let request = AttemptFetchRequest(profileId: userId)
        let (attempts, status) = try await attemptRepository.fetchAttempts(request: request)
        
        guard status == .success else {
            return []
        }
        
        for attempt in attempts {
            debugPrint(attempt.attemptDateTime)
            let attemptEntity = AttemptDataEntity(attemptId: attempt.attemptId.uuidString,
                                                  storyId: attempt.storyId.uuidString,
                                                  date: DateUtils.getDatabaseTimestamp(from: attempt.attemptDateTime) ?? Date(),
                                                  kosakataPercentage: Int(attempt.kosakataPercentage),
                                                  idePokokPercentage: Int(attempt.idePokokPercentage),
                                                  implisitPercentage: Int(attempt.implisitPercentage),
                                                  soundPath: attempt.recordSoundPath
            )
            
            attemptEntities.append(attemptEntity)
        }
        
        return attemptEntities
    }
    
    @MainActor
    public func playRecordSound() async throws {
        guard let user = userData else {
            debugPrint("User Data not found")
            currentlyPlayedAttemptId = ""
            return
        }
        
        guard let userId = UUID(uuidString: user.id) else {
            debugPrint("Invalid UserId")
            currentlyPlayedAttemptId = ""
            return
        }
        
        guard let attemptUuid = UUID(uuidString: currentlyPlayedAttemptId ?? "") else {
            debugPrint("Invalid attemptId")
            currentlyPlayedAttemptId = ""
            return
        }
        
        let request = RecordSoundRequest(userId: userId, attemptId: attemptUuid, soundData: Data())
        let (sound, status) = try await recordSoundRepository.downloadSound(request: request)
        
        if let soundResult = sound, status == .success {
            do {
                audioPlayer = try AVAudioPlayer(data: soundResult.soundData)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                debugPrint("Playing sound from data")
            } catch {
                debugPrint("Failed to play sound from data: \(error)")
                currentlyPlayedAttemptId = ""
            }
        } else {
            debugPrint("Failed to download sound")
            currentlyPlayedAttemptId = ""
        }
    }
    
    public func stopRecordSound() {
        audioPlayer?.stop()
        currentlyPlayedAttemptId = ""
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("Audio finished playing successfully")
        currentlyPlayedAttemptId = ""
    }
}
