//
//  SearchStoryViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

class SearchStoryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var savedStories: [StoryEntity] = []
    @Published var searchResult: [StoryEntity] = []
    @Published var isLoading: Bool = false
    
    private var storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository) {
        self.storyRepository = storyRepository
    }
    
    @MainActor
    func fetchAllStories() async throws {
        isLoading = true
        savedStories = []
        
        let (stories, status) = try await storyRepository.fetchStories()
        
        guard status == .success else {
            debugPrint("Fetch unsuccessful")
            savedStories = []
            return
        }
        
        for story in stories {
            savedStories.append(StoryEntity(storyId: story.storyId.uuidString,
                                            storyName: story.storyName,
                                            storyDescription: story.storyDescription,
                                            storyImageName: story.storyCoverImagePath,
                                            baseBalance: 10 //MARK: Discuss this with Hans
                                           )
            )
        }
        
        isLoading = false
    }
    
    @MainActor
    func searchStory() async throws {
        isLoading = true
        searchResult = []
        
        searchResult = savedStories.filter { story in
            story.storyName.lowercased().contains(searchText.lowercased())
        }
        
        isLoading = false
    }
}
