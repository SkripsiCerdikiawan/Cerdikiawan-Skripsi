//
//  SearchStoryViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

class SearchStoryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResult: [StoryEntity] = []
    @Published var isLoading: Bool = false
    
    private var storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository) {
        self.storyRepository = storyRepository
    }
    
    @MainActor
    public func searchStory() async throws {
        isLoading = true
        searchResult = []
        let (stories, status) = try await storyRepository.fetchStories()
        
        guard status == .success else {
            debugPrint("Fetch unsuccessful")
            searchResult = []
            return
        }
        
        let filteredStories = stories.filter { story in
            story.storyName.lowercased().contains(searchText.lowercased())
        }
        for story in filteredStories {
            searchResult.append(StoryEntity(storyId: story.storyId.uuidString,
                                            storyName: story.storyName,
                                            storyDescription: story.storyDescription,
                                            storyImageName: story.storyCoverImagePath,
                                            baseBalance: 10 //MARK: Discuss this with Hans
                                           )
            )
        }
        isLoading = false
    }
}
