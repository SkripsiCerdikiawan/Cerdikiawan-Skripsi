//
//  CerdikiawanReportDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ReportDataViewModel: ObservableObject {
    @Published var userData: UserEntity?
    @Published var reportData: ReportDataEntity?
    @Published var levelList: [ReportLevelEntity] = []
    
    private var userAttempts: [AttemptDataEntity] = []
    
    private var storyRepository: StoryRepository
    private var attemptRepository: AttemptRepository
    
    init(storyRepository: StoryRepository, attemptRepository: AttemptRepository) {
        self.storyRepository = storyRepository
        self.attemptRepository = attemptRepository
    }
    
    @MainActor
    func setup() async throws {
        userAttempts = try await fetchAllUserAttempt()
        reportData = try await fetchReportData()
        levelList = try await fetchLevelListData()
    }
    
    @MainActor
    private func fetchAllUserAttempt() async throws -> [AttemptDataEntity] {
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
            let attemptEntity = AttemptDataEntity(attemptId: attempt.attemptId.uuidString,
                                                  storyId: attempt.storyId.uuidString,
                                                  date: DateUtils.getDatabaseDate(from: attempt.attemptDateTime) ?? Date(),
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
    func fetchReportData() async throws -> ReportDataEntity {
        guard userAttempts.isEmpty == false else {
            return ReportDataEntity(kosakataPercentage: 0, idePokokPercentage: 0, implisitPercentage: 0)
        }
        
        var kosakataTotal: Int = 0
        var kosakataCount: Int = 0
        var idePokokTotal: Int = 0
        var idePokokCount: Int = 0
        var implisitTotal: Int = 0
        var implisitCount: Int = 0
        
        for userAttempt in userAttempts {
            if userAttempt.kosakataPercentage != -1 {
                kosakataTotal += userAttempt.kosakataPercentage
                kosakataCount += 1
            }
            
            if userAttempt.idePokokPercentage != -1 {
                idePokokTotal += userAttempt.idePokokPercentage
                idePokokCount += 1
            }
            
            if userAttempt.implisitPercentage != -1 {
                implisitTotal += userAttempt.implisitPercentage
                implisitCount += 1
            }
        }
        return ReportDataEntity(kosakataPercentage: kosakataCount == 0 ? 0 : kosakataTotal / kosakataCount,
                                idePokokPercentage: idePokokCount == 0 ? 0 : idePokokTotal / idePokokCount,
                                implisitPercentage: implisitCount == 0 ? 0 : implisitTotal / implisitCount
        )
    }
    
    @MainActor
    func fetchLevelListData() async throws -> [ReportLevelEntity] {
        var levelList = ReportLevelEntity.mock()
        let (stories, status) = try await storyRepository.fetchStories()
        
        guard status == .success else {
            debugPrint("Fetch unsuccessful")
            return []
        }
        
        for story in stories {
            if var level = levelList.first(where: {$0.level == story.storyLevel}) {
                var entity = ReportStoryEntity(storyId: story.storyId.uuidString,
                                               storyName: story.storyName,
                                               storyDescription: story.storyDescription,
                                               storyImageName: story.storyCoverImagePath,
                                               attemptStatus: userAttempts.contains(where: { $0.storyId == story.storyId.uuidString }),
                                               storyLevel: level.level
                )
                level.stories.append(entity)
                
                if let index = levelList.firstIndex(where: { $0.level == story.storyLevel }) {
                    levelList[index] = level
                }
            }
        }
        return levelList
    }
    
    // MARK: - Business Logic
    func determineSummaryStyle(value: Int) -> CerdikiawanScoreStyle {
        switch value {
        case -1..<25:
            return .low
        case 25..<50:
            return .normal
        case 50..<80:
            return .great
        case 80..<101:
            return .great
        default:
            return .low
        }
    }
}
