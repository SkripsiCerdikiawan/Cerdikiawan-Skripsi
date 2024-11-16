//
//  CerdikiawanTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 09/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct CerdikiawanTests {
    var storyRepository: StoryRepository
    
    init() async throws {
        storyRepository = SupabaseStoryRepository.shared
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func fetchStories() async throws {
        //TODO: Add auth process
        let (stories, status) = try await storyRepository.fetchStories()
        
        #expect(!stories.isEmpty && status == .success, "Stories should be fetched")
    }

    
    @Test func fetchStoryById() async throws {
        //TODO: Add auth process
        let request = StoryRequest(storyId: UUID(uuidString: "ccbed71f-ea39-425d-8238-838f74498a93"))
        let (story, status) = try await storyRepository.fetchStoryById(request: request)
        
        #expect(story != nil && status == .success, "Story should be fetched")
        #expect(story?.storyId == UUID(uuidString: "ccbed71f-ea39-425d-8238-838f74498a93"), "storyId does not match")
    }
}
