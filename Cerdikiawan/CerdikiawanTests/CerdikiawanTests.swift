//
//  CerdikiawanTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 09/11/24.
//

import Testing
@testable import Cerdikiawan

struct CerdikiawanTests {

    @Test func example() async throws {
        
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func fetchStories() async throws {
        let storyRepository: StoryRepository = SupabaseStoryRepository.shared
        
        let stories = try await storyRepository.fetchStories()
        
        
        #expect(!stories.isEmpty, "Stories should be fetched")
    }

}
