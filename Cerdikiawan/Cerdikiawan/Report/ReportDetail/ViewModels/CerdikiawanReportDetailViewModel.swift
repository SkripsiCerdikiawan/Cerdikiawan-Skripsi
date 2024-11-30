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
    
    private var attemptRepository: AttemptRepository
    
    init(story: ReportStoryEntity, attemptRepository: AttemptRepository) {
        self.story = story
        self.attemptRepository = attemptRepository
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
    
    public func playRecordSound() {
        //TODO: Fetch and play recroding sound here
    }
}
