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
    
    // singleton
    public static let shared = SupabaseStoryRepository()
    private override init () {}
    
    // Fetch all stories
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
                guard stories.isEmpty == false else {
                    return ([], .notFound)
                }
                return (stories, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    // Fetch stories based on storyId
    func fetchStoryById(request: StoryRequest) async throws -> (SupabaseStory?, ErrorStatus) {
        do {
            guard request.storyId != nil else {
                return (nil, .invalidInput)
            }
            
            var query = client
                .from("Story")
                .select()
            
            if let storyId = request.storyId {
                query = query
                    .eq("storyId", value: storyId)
            }
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return (nil, .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseStory].self)
            
            switch result {
            case .success(let story):
                return (story.first, .success)
            case .failure(_):
                return (nil, .jsonError)
            }
        } catch {
            return (nil, .notFound)
        }
    }
}
