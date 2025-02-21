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
    
    // singleton
    public static let shared = SupabaseParagraphRepository()
    private override init() {}
    
    //fetch all available paragraphs
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
                guard paragraph.isEmpty == false else {
                    return ([], .notFound)
                }
                return (paragraph, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    //fetch paragraph based on request
    func fetchParagraphsById(request: ParagraphRequest) async throws -> ([SupabaseParagraph], ErrorStatus) {
        
        do {
            guard request.pageId != nil || request.paragraphId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("Paragraph")
                .select()
            
            if let pageId = request.pageId {
                query = query
                    .eq("pageId", value: pageId)
            }
            
            if let paragraphId = request.paragraphId {
                query = query
                    .eq("paragraphId", value: paragraphId)
            }
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseParagraph].self)
            
            switch result {
            case .success(let paragraph):
                guard paragraph.isEmpty == false else {
                    return ([], .notFound)
                }
                return (paragraph, .success)
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
}
