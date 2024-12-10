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
    
    init(storyRepository: StoryRepository) {
        self.storyRepository = storyRepository
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
        
        // Map stories into storyList
        self.storyList = stories.map({ story in
            let storyEntity = StoryEntity(
                storyId: story.storyId.uuidString,
                storyName: story.storyName,
                storyDescription: story.storyDescription,
                storyImageName: story.storyCoverImagePath,
                baseBalance: 10 // MARK: Discuss this more with Hans
            )
            
            // Append story to level
            if let idx = levelList.firstIndex(where: {
                $0.level == story.storyLevel
            }) {
                levelList[idx].stories.append(storyEntity)
            }
            
            return storyEntity
        })
        
        return levelList
    }
}
