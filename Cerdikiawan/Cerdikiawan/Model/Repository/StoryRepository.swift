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

class SupabaseStoryRepository: SupabaseRepository, StoryRepository {
    
    public static let shared = SupabaseStoryRepository()
    private override init () {}
    
    //Fetch all stories
    func fetchStories() async throws -> ([SupabaseStory], ErrorStatus) {
        let response = try await client
            .from("Story")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
            
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseStory].self)
        
        switch result {
            case .success(let stories):
                return (stories, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    //fetch stories based on storyId
    func fetchStoryById(request: StoryRequest) async throws -> (SupabaseStory?, ErrorStatus) {
        let (stories, status) = try await fetchStories()
        
        if let storyId = request.storyId {
            guard status == .success else {
                return (nil, .serverError)
            }
            guard let story = stories.first(where: {$0.storyId == storyId} ) else {
                return (nil, .notFound)
            }
            return (story, .success)
        } else {
            return (nil, .invalidInput)
        }
    }
}
