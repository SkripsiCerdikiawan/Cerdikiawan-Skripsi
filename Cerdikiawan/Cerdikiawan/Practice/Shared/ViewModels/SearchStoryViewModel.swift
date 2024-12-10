//
//  SearchStoryViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

class SearchStoryViewModel: ObservableObject {
    let storyList: [StoryEntity]
    
    @Published var searchText: String = ""
    @Published var searchResult: [StoryEntity] = []
    
    init(storyList: [StoryEntity]) {
        self.storyList = storyList
    }
    
    func filterStory() {
        searchResult = storyList.filter({
            $0.storyName.contains(searchText)
        })
    }
}
