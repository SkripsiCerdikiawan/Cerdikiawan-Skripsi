//
//  StoryTests 2.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct PageTests {
    var pageRepository: PageRepository
    
    init() async throws {
        pageRepository = SupabasePageRepository.shared
    }
    
    @Test func testFetchPages() async throws {
        let (pages, status) = try await pageRepository.fetchPages()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!pages.isEmpty,
                "Page should not be empty"
        )
        
        debugPrint(pages)
    }
    
    @Test func testFetchPagesByPageId() async throws {
        let request = PageRequest(pageId: UUID(uuidString: "c329032f-f5Ed-47b8-9a41-e9b3f8688873"))
        let (pages, status) = try await pageRepository.fetchPagesById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!pages.isEmpty,
                "Page should not be empty"
        )
        
        #expect(pages.count == 1 &&
                pages.contains(where: { $0.pageId == request.pageId }),
                "Page should match the intended pageId"
        )
    }
    
    @Test func testFetchPagesByStoryId() async throws {
        let request = PageRequest(storyId: UUID(uuidString: "2fa5caf7-c4f9-4f13-9ee1-8c8b2ff8fbfc"))
        let (pages, status) = try await pageRepository.fetchPagesById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!pages.isEmpty,
                "Page should not be empty"
        )
        
        #expect(pages.count == 5 &&
                pages.allSatisfy( { $0.storyId == request.storyId } ),
                "Page should match the intended storyId"
        )
    }
    
    @Test func testFetchInvalidId() async throws {
        let request = PageRequest(pageId: UUID(uuidString: "wrong id"))
        let (pages, status) = try await pageRepository.fetchPagesById(request: request)
        
        #expect(pages.isEmpty &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
