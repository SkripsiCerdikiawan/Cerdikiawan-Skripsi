//
//  ResultDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ResultDataViewModels: ObservableObject {
    let character: CharacterEntity
    @Published var resultEntity: ResultDataEntity
    
    private var attemptRepository: AttemptRepository
    private var profileRepository: ProfileRepository
    private var recordRepository: RecordSoundStorageRepository
    
    init(
        character: CharacterEntity,
        resultEntity: ResultDataEntity,
        attemptRepository: AttemptRepository,
        profileRepository: ProfileRepository,
        recordRepository: RecordSoundStorageRepository
    ) {
        self.character = character
        self.resultEntity = resultEntity
        self.attemptRepository = attemptRepository
        self.profileRepository = profileRepository
        self.recordRepository = recordRepository
    }
    
    // TODO: Replace with repo
    @MainActor
    func saveAttemptData(userID: String) async throws -> Bool {
        let attemptId = UUID()
        guard let userUuid = UUID(uuidString: userID) else {
            debugPrint("UserId not found")
            return false
        }
        
        guard let storyId = UUID(uuidString: resultEntity.storyId) else {
            debugPrint("StoryId not found")
            return false
        }
        
        // Save recording data
        // MARK: Mungkin bisa jadi optional to Data(), not thrown
        guard let recordSoundData = VoiceRecordingHelper.shared.getRecordingData() else {
            debugPrint("Recording data not found")
            return false
        }
        
        let recordRequest = RecordSoundRequest(userId: userUuid,
                                               attemptId: attemptId,
                                               soundData: recordSoundData
        )
        let (records, recordStatus) = try await recordRepository.uploadSoundFile(request: recordRequest)
        
        guard recordStatus == .success, let recordResult = records else {
            debugPrint("Failed to upload recording data")
            return false
        }
        
        // Add attempt
        let attemptRequest = AttemptInsertRequest(attemptId: attemptId,
                                                  profileId: userUuid,
                                                  storyId: storyId,
                                                  attemptDateTime: DateUtils.getDatabaseTimestamp(from: Date.now),
                                                  kosakataPercentage: Float(resultEntity.kosakataPercentage),
                                                  idePokokPercentage: Float(resultEntity.idePokokPercentage),
                                                  implisitPercentage: Float(resultEntity.implisitPercentage),
                                                  recordSoundPath: recordResult.soundPath
        )
        let (attempts, attemptResult) = try await attemptRepository.createNewAttempt(request: attemptRequest)
        
        guard attemptResult == .success, attempts != nil else {
            debugPrint("Failed to add attempt data")
            return false
        }
        
        // Add balance to user
        let profileRequest = ProfileUpdateRequest(profileId: userUuid,
                                                  profileBalance: resultEntity.baseBalance * resultEntity.correctCount
        )
        let (profile, profileStatus) = try await profileRepository.updateProfile(request: profileRequest)
        
        guard profileStatus == .success, profile != nil else {
            debugPrint("Failed to update user profile balance")
            return false
        }
        
        debugPrint("Saving user data...")
        return true
    }
}
