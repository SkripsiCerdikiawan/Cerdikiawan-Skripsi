//
//  CerdikiawanReportDetailViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

class CerdikiawanReportDetailViewModel: ObservableObject {
    @Published var userData: UserEntity?
    @Published var story: ReportStoryEntity
    @Published var currentlyPlayedAttemptId: String?
    @Published var attempts: [AttemptDataEntity] = []
    
    @Published var isSoundPlaying = false
    
    private var attemptRepository: AttemptRepository
    private var recordSoundRepository: RecordSoundStorageRepository
    
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
    public func playRecordSound(attemptId: String) async throws {
        guard let user = userData else {
            debugPrint("User Data not found")
            return
        }
        
        guard let userId = UUID(uuidString: user.id) else {
            debugPrint("Invalid UserId")
            return
        }
        
        guard let attemptUuid = UUID(uuidString: attemptId) else {
            debugPrint("Invalid attemptId")
            return
        }
        
        let request = RecordSoundRequest(userId: userId, attemptId: attemptUuid, soundData: Data())
        let (sound, status) = try await recordSoundRepository.downloadSound(request: request)
        
        if let soundResult = sound, status == .success {
            let localURL = saveSoundToDevice(fileName: soundResult.soundPath, soundData: soundResult.soundData)
            if let localURL = localURL {
                debugPrint("Sound saved locally at: \(localURL)")
                
                guard FileManager.default.fileExists(atPath: localURL.path) else {
                    debugPrint("File does not exist at path: \(localURL.path)")
                    return
                }
                
                isSoundPlaying = true
                VoiceRecordingHelper.shared.playSoundFromFile(url: localURL, completion: {
                    self.isSoundPlaying = false
                })
            } else {
                debugPrint("Failed to save sound locally")
            }
        } else {
            debugPrint("Failed to download sound")
        }
    }
    
    public func stopRecordSound() {
        VoiceRecordingHelper.shared.stopSound()
        isSoundPlaying = false
    }
    
    private func saveSoundToDevice(fileName: String, soundData: Data) -> URL? {
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debugPrint("Failed to access Documents directory")
            return nil
        }
        
        let directoryURL = documentsURL.appendingPathComponent(fileName)
        let directoryPath = directoryURL.deletingLastPathComponent()
        
        do {
            if !fileManager.fileExists(atPath: directoryPath.path) {
                try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                debugPrint("Created directory at: \(directoryPath.path)")
            }
            
            let soundFileURL = directoryURL.appendingPathExtension("mp3")
            
            try soundData.write(to: soundFileURL)
            debugPrint("Sound saved successfully at: \(soundFileURL)")
            return soundFileURL
            
        } catch {
            debugPrint("Failed to save sound file: \(error)")
            return nil
        }
    }
}
