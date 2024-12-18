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
        
        do {
            guard request.pageId != nil || request.storyId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("Page")
                .select()
            
            if let pageId = request.pageId {
                query = query
                    .eq("pageId", value: pageId)
            }
            
            if let storyId = request.storyId {
                query = query
                    .eq("storyId", value: storyId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabasePage].self)
            
            switch result {
            case .success(let page):
                guard page.isEmpty == false else {
                    return ([], .notFound)
                }
                return (page, .success)
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
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
