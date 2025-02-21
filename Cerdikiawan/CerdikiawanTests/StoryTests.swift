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
    
    @Test func testFetchStories() async throws {
        let (stories, status) = try await storyRepository.fetchStories()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!stories.isEmpty,
                "Stories should not be empty"
        )
    }
    
    @Test func testFetchStoryById() async throws {
        let request = StoryRequest(storyId: UUID(uuidString: "2fa5caf7-c4f9-4f13-9ee1-8c8b2ff8fbfc"))
        let (story, status) = try await storyRepository.fetchStoryById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(story != nil,
                "Story should be fetched"
        )
        
        #expect(story?.storyId == request.storyId,
                "storyId does not match"
        )
    }
    
    @Test func testFetchInvalidId() async throws {
        let request = StoryRequest()
        let (story, status) = try await storyRepository.fetchStoryById(request: request)
        
        #expect(story == nil &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
