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
    }
    
    @Test func testFetchPagesByPageId() async throws {
        let request = PageRequest(pageId: UUID(uuidString: "ae244295-e2cc-4279-a32e-e3f3e034a05c"))
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
        let request = PageRequest(storyId: UUID(uuidString: "ccbed71f-ea39-425d-8238-838f74498a93"))
        let (pages, status) = try await pageRepository.fetchPagesById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!pages.isEmpty,
                "Page should not be empty"
        )
        
        #expect(pages.count == 2 &&
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
