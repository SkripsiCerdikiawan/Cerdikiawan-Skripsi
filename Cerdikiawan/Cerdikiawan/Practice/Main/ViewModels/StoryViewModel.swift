//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class StoryViewModel: ObservableObject {
    let story: StoryEntity
    
    init(story: StoryEntity) {
        self.story = story
    }
}
