//
//  PageRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol PageRepository {
    func fetchPages() async throws -> ([SupabasePage], ErrorStatus)
    func fetchPagesById(request: PageRequest) async throws -> ([SupabasePage], ErrorStatus)
    func fetchPagesCount(request: PageRequest) async throws -> (Int, ErrorStatus)
}

class SupabasePageRepository: SupabaseRepository, PageRepository {
    
    public static let shared = SupabasePageRepository()
    private override init () {}
    
    func fetchPages() async throws -> ([SupabasePage], ErrorStatus) {
        let response = try await client
            .from("Page")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
            
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabasePage].self)
        
        switch result {
            case .success(let pages):
                guard pages.isEmpty == false else {
                    return ([], .notFound)
                }
                return (pages, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    func fetchPagesById(request: PageRequest) async throws -> ([SupabasePage], ErrorStatus) {
        let (pages, status) = try await fetchPages()
        
        guard status == .success else {
            return ([], .serverError)
        }
        
        guard request.pageId != nil || request.storyId != nil else {
            return ([], .invalidInput)
        }
        
        var sortedPages = pages
        
        if let pageId = request.pageId {
            sortedPages = sortedPages.filter( {$0.pageId == pageId} )
        }
        
        if let storyId = request.storyId {
            sortedPages = sortedPages.filter( {$0.storyId == storyId} )
        }
        
        guard !sortedPages.isEmpty else {
            return ([], .notFound)
        }
        
        return (sortedPages, .success)
    }
    
    func fetchPagesCount(request: PageRequest) async throws -> (Int, ErrorStatus) {
        let response = try await client
            .from("Page")
            .select("*", head: true, count: .exact)
            .eq("storyId", value: request.storyId)
            .execute()
        
        guard response.status == 200 else {
            return (0, .serverError)
        }
        
        guard let result = response.count else {
            return (0, .success)
        }
        
        return (result, .success)
    }
    
    
}
