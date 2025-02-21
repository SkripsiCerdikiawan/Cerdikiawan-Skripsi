//
//  ParagraphTest.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct ParagraphTests {
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
        let request = ParagraphRequest(paragraphId: UUID(uuidString: "41320247-a91c-4e0e-86df-bc14c151b6d9"))
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
        let request = ParagraphRequest(pageId: UUID(uuidString: "c5b15055-52b3-4299-88a3-a9b4b4a873c4"))
        let (paragraphs, status) = try await paragraphRepository.fetchParagraphsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!paragraphs.isEmpty,
                "Paragraphs should not be empty"
        )
        
        #expect(paragraphs.count == 3 &&
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
