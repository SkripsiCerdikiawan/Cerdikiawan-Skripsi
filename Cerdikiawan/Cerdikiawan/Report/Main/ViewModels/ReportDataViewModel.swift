//
//  CerdikiawanReportDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ReportDataViewModel: ObservableObject {
    @Published var userId: String?
    @Published var reportData: ReportDataEntity?
    @Published var levelList: [ReportLevelEntity] = []
    
    private var storyRepository: StoryRepository
    private var attemptRepository: AttemptRepository
    
    init(storyRepository: StoryRepository, attemptRepository: AttemptRepository) {
        self.storyRepository = storyRepository
        self.attemptRepository = attemptRepository
    }
    
    @MainActor
    func setup() async throws {
        reportData = fetchReportData()
        levelList = try await fetchLevelListData()
    }
    
    // TODO: Replace with repo
    func fetchReportData() -> ReportDataEntity {
//        let request = AttemptFetchRequest(profileId: <#T##UUID#>)
//        let (attempts, status) = try await attemptRepository.fetchAttempts(request: <#T##AttemptFetchRequest#>)
        return ReportDataEntity.mock()[3]
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
            let entity = ReportStoryEntity(storyId: story.storyId,
                                     storyName: story.storyName,
                                     storyDescription: story.storyDescription,
                                     storyImageName: story.storyCoverImagePath,
                                     attemptStatus: false // MARK: Discuss with Hans
            )
            if var level = levelList.first(where: {$0.level == story.storyLevel}) {
                level.stories.append(entity)
                // Update the levelList with the modified level
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
