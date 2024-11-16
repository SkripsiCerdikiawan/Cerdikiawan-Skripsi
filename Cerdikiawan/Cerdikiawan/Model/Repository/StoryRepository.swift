//
//  StoryRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 14/11/24.
//

import Foundation
import Supabase

protocol StoryRepository {
    func fetchStories() async throws -> ([SupabaseStory], ErrorStatus)
    func fetchStoryById(request: StoryRequest) async throws -> (SupabaseStory?, ErrorStatus)
}

class SupabaseStoryRepository: StoryRepository {
    let client = SupabaseClient(supabaseURL: URL(string: APIKey.dbUrl)!, supabaseKey: APIKey.key)
    
    public static var shared = SupabaseStoryRepository()
    
    private init () {}
    
    //Fetch all stories
    func fetchStories() async throws -> ([SupabaseStory], ErrorStatus) {
        let stories: [SupabaseStory] = try await client
          .from("Story")
          .select()
          .execute()
          .value
        
        guard !stories.isEmpty else {
            return ([], .notFound)
        }
        
        return (stories, .success)
    }
    
    //fetch stories based on storyId
    func fetchStoryById(request: StoryRequest) async throws -> (SupabaseStory?, ErrorStatus) {
        let stories = try await fetchStories().0
        
        if let storyId = request.storyId {
            guard let story = stories.first(where: {$0.storyId == storyId} ) else {
                return (nil, .notFound)
            }
            
            return (story, .success)
        } else {
            return (nil, .invalidInput)
        }
    }
}
