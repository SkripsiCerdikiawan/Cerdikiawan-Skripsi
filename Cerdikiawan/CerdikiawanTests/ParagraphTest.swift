//
//  ParagraphTest.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct ParagraphTest {
    var paragraphRepository: ParagraphRepository
    
    init() async throws {
        paragraphRepository = SupabaseParagraphRepository.shared
    }
    
    @Test func testFetchParagraphs() async throws {
        let (paragraphs, status) = try await paragraphRepository.fetchParagraphs()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!paragraphs.isEmpty,
                "Paragraphs should not be empty"
        )
    }
    
    @Test func testFetchParagraphByParagraphId() async throws {
        let request = ParagraphRequest(paragraphId: UUID(uuidString: "73628f42-26ab-4c43-ae49-649711fe962d"))
        let (paragraphs, status) = try await paragraphRepository.fetchParagraphsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!paragraphs.isEmpty,
                "Paragraphs should not be empty"
        )
        
        #expect(paragraphs.count == 1 &&
                paragraphs.contains(where: { $0.paragraphId == request.paragraphId }),
                "Paragraphs should match the intended paragraphId"
        )
    }
    
    @Test func testFetchParagraphByPageId() async throws {
        let request = ParagraphRequest(pageId: UUID(uuidString: "ae244295-e2cc-4279-a32e-e3f3e034a05c"))
        let (paragraphs, status) = try await paragraphRepository.fetchParagraphsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!paragraphs.isEmpty,
                "Paragraphs should not be empty"
        )
        
        #expect(paragraphs.count == 2 &&
                paragraphs.contains(where: { $0.pageId == request.pageId }),
                "Paragraphs should match the intended paragraphId"
        )
    }
    
    @Test func testFetchInvalidId() async throws {
        let request = ParagraphRequest(paragraphId: UUID(uuidString: "wrong id"))
        let (paragraphs, status) = try await paragraphRepository.fetchParagraphsById(request: request)
        
        #expect(paragraphs.isEmpty &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
