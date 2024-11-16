//
//  StoryRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 14/11/24.
//

import Foundation

protocol

class StoryRepository: SupabaseDatabaseRepository {
    
    public static var shared = SupabaseDatabaseRepository()
    
//    private override init () {}
    
    func fetchStories() async throws -> [SupabaseStory] {
        let story: [SupabaseStory] = try await client
          .from("Story")
          .select()
          .execute()
          .value
        print(story)
        return story
    }
}
