//
//  ParagraphRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol ParagraphRepository {
    func fetchParagraphs() async throws -> ([SupabaseParagraph], ErrorStatus)
    func fetchParagraphsById(request: ParagraphRequest) async throws -> ([SupabaseParagraph], ErrorStatus)
}

class SupabaseParagraphRepository: SupabaseRepository, ParagraphRepository {
    
    public static let shared = SupabaseParagraphRepository()
    private override init() {}
    
    func fetchParagraphs() async throws -> ([SupabaseParagraph], ErrorStatus) {
        let response = try await client
            .from("Paragraph")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
            
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseParagraph].self)
        
        switch result {
            case .success(let paragraph):
                return (paragraph, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    func fetchParagraphsById(request: ParagraphRequest) async throws -> ([SupabaseParagraph], ErrorStatus) {
        let (paragraphs, status) = try await fetchParagraphs()
        
        guard status == .success else {
            return ([], .serverError)
        }
        
        guard request.pageId != nil || request.paragraphId != nil else {
            return ([], .invalidInput)
        }
        
        var sortedParagraphs = paragraphs
        
        if let pageId = request.pageId {
            sortedParagraphs = sortedParagraphs.filter( {$0.pageId == pageId} )
        }
        
        if let paragraphId = request.paragraphId {
            sortedParagraphs = sortedParagraphs.filter( {$0.paragraphId == paragraphId} )
        }
        
        guard !sortedParagraphs.isEmpty else {
            return ([], .notFound)
        }
        
        return (sortedParagraphs, .success)
    }
}
