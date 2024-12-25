//
//  LevelListViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

class LevelListViewModel: ObservableObject {
    @Published var storyList: [StoryEntity] = []
    
    @Published var levels: [LevelEntity] = []
    @Published var isLoading: Bool = true
    
    private var storyRepository: StoryRepository
    private var pageRepository: PageRepository
    
    init(
        storyRepository: StoryRepository,
        pageRepository: PageRepository
    ) {
        levels = []
        self.storyRepository = storyRepository
        self.pageRepository = pageRepository
    }
    
    @MainActor
    func setup() async throws {
        levels = try await fetchLevel()
    }
    
    @MainActor
    func fetchLevel() async throws -> [LevelEntity] {
        var levelList = LevelEntity.mock()
        let (stories, status) = try await storyRepository.fetchStories()
        
        guard status == .success else {
            debugPrint("Fetch unsuccessful")
            return []
        }
        
        // Improve performance by fetching all data async
        let storyEntities = try await withThrowingTaskGroup(of: StoryEntity.self) { group in
            for story in stories {
                group.addTask {
                    let baseBalance = self.getLevelbaseBalance(level: story.storyLevel)
                    let availableCoin = try await self.calculateAvailableCoin(storyID: story.storyId, baseBalance: baseBalance)
                    let storyEntity = StoryEntity(
                        storyId: story.storyId.uuidString,
                        storyName: story.storyName,
                        storyDescription: story.storyDescription,
                        storyImageName: story.storyCoverImagePath,
                        baseBalance: baseBalance,
                        availableCoinToGain: availableCoin
                    )
                    
                    if let idx = levelList.firstIndex(where: { $0.level == story.storyLevel }) {
                        levelList[idx].stories.append(storyEntity)
                    }
                    
                    return storyEntity
                }
            }
            
            var results: [StoryEntity] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }

        self.storyList = storyEntities
        return levelList
    }

    
    private func calculateAvailableCoin(storyID: UUID, baseBalance: Int) async throws -> Int {
        // fetch page
        let pageRequest = PageRequest(storyId: storyID)
        let (pageCount, pageStatus) = try await pageRepository.fetchPagesCount(request: pageRequest)
        
        guard pageStatus == .success, pageCount > 0 else {
            debugPrint("Page is not found for \(storyID)")
            isLoading = false
            return 0
        }
        return pageCount * baseBalance
    }
    
    private func getLevelbaseBalance(level: Int) -> Int {
        switch level {
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 3
        default:
            return 0
        }
    }
}
