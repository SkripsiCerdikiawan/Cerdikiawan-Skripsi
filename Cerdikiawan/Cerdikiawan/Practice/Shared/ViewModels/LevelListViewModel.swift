//
//  LevelListViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

class LevelListViewModel: ObservableObject {
    @Published var levels: [LevelEntity]
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
        
        for story in stories {
            // get available coin
            let baseBalance = getLevelbaseBalance(level: story.storyLevel)
            let availableCoint = try await calculateAvailableCoin(storyID: story.storyId, baseBalance: baseBalance)
            
            let entity = StoryEntity(storyId: story.storyId.uuidString,
                                     storyName: story.storyName,
                                     storyDescription: story.storyDescription,
                                     storyImageName: story.storyCoverImagePath,
                                     baseBalance: baseBalance,
                                     availableCoinToGain: availableCoint
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
    
    private func calculateAvailableCoin(storyID: UUID, baseBalance: Int) async throws -> Int {
        // fetch page
        let pageRequest = PageRequest(storyId: storyID)
        let (pages, pageStatus) = try await pageRepository.fetchPagesById(request: pageRequest)
        
        guard pageStatus == .success, pages.isEmpty == false else {
            debugPrint("Page did not get fetched")
            isLoading = false
            return 1
        }
        
        return pages.count * baseBalance
    }
    
    private func getLevelbaseBalance(level: Int) -> Int {
        switch level {
        case 1:
            return 1
        case 2:
            return 5
        case 3:
            return 10
        default:
            return 1
        }
    }
}
