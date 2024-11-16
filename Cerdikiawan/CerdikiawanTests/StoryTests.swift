//
//  CerdikiawanTests.swift
//  StoryTests
//
//  Created by Nathanael Juan Gauthama on 09/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct StoryTests {
    var storyRepository: StoryRepository
    
    init() async throws {
        storyRepository = SupabaseStoryRepository.shared
    }
    
    @Test func fetchStories() async throws {
        //TODO: Add auth process
        let (stories, status) = try await storyRepository.fetchStories()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!stories.isEmpty,
                "Stories should not be empty"
        )
    }
    
    @Test func fetchStoryById() async throws {
        //TODO: Add auth process
        let request = StoryRequest(storyId: UUID(uuidString: "ccbed71f-ea39-425d-8238-838f74498a93"))
        let (story, status) = try await storyRepository.fetchStoryById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(story != nil,
                "Story should be fetched"
        )
        
        #expect(story?.storyId == UUID(uuidString: "ccbed71f-ea39-425d-8238-838f74498a93"),
                "storyId does not match"
        )
    }
    
    @Test func fetchInvalidId() async throws {
        let request = StoryRequest()
        let (story, status) = try await storyRepository.fetchStoryById(request: request)
        
        #expect(story == nil &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
