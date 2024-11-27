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
    
    public func searchStory(){
        let allStory = StoryEntity.mock()
        
        let filteredStories = allStory.filter { story in
            story.storyName.lowercased().contains(searchText.lowercased())
        }
        self.searchResult = filteredStories
    }
}
