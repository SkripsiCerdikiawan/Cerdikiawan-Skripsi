//
//  Story.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseStory: Codable {
    let StoryID: UUID
    let StoryName: String
    let StoryDescription: String
    let StoryLevel: Int
    let StoryCoverImagePath: String
}
