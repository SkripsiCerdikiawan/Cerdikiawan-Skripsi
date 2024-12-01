//
//  ResultDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ResultDataViewModels: ObservableObject {
    let character: CharacterEntity
    var user: UserEntity?
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
    func saveAttemptData(userID: String) -> Bool {
        // Save recording data
//        let recordRequest = RecordSoundRequest(userId: <#T##UUID#>,
//                                               attemptId: <#T##UUID#>,
//                                               soundData: <#T##Data#>
//        )
        
        
        
        // Add attempt
//        let attemptRequest = AttemptInsertRequest(attemptId: UUID(),
//                                                  profileId: <#T##UUID#>,
//                                                  storyId: <#T##UUID#>,
//                                                  attemptDateTime: DateUtils.getDatabaseTimestamp(from: Date.now),
//                                                  kosakataPercentage: <#T##Float#>,
//                                                  idePokokPercentage: <#T##Float#>,
//                                                  implisitPercentage: <#T##Float#>,
//                                                  recordSoundPath: <#T##String#>
//        )
        
        
        // Add balance to user
//        let profileRequest = ProfileUpdateRequest(profileId: <#T##UUID#>,
//                                                  profileBalance: <#T##Int?#>
//        )
        
        
        debugPrint("Saving user data...")
        return true
    }
}
