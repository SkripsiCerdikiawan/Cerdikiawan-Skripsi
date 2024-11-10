//
//  Story.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseStory: Codable {
    let storyId: UUID
    let storyName: String
    let storyDescription: String
    let storyLevel: Int
    let storyCoverImagePath: String
}
