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
    
    @Published var storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository) {
        levels = []
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
        
        for story in stories {
            let entity = StoryEntity(storyId: story.storyId.uuidString,
                                     storyName: story.storyName,
                                     storyDescription: story.storyDescription,
                                     storyImageName: story.storyCoverImagePath,
                                     baseBalance: 10 // MARK: Discuss this more with Hans
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
}
