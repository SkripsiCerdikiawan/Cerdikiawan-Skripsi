//
//  AnswerRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol AnswerRepository {
    func fetchAnswers() async throws -> ([SupabaseAnswer], ErrorStatus)
    func fetchAnswersById<T: SupabaseAnswer>(request: AnswerRequest) async throws -> ([T], ErrorStatus)
}

class SupabaseWordBlankAnswerRepository: SupabaseRepository, AnswerRepository {
    
    //singleton
    public static let shared = SupabaseWordBlankAnswerRepository()
    private override init() {}
    
    //Fetch all word blank answers
    func fetchAnswers() async throws -> ([SupabaseAnswer], ErrorStatus) {
        let response = try await client
            .from("WordBlankAnswer")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseWordBlankAnswer].self)
        
        switch result {
        case .success(let answers):
            guard answers.isEmpty == false else {
                return ([], .notFound)
            }
            return (answers, .success)
        case .failure(_):
            return ([], .jsonError)
        }
    }
    
    //Fetch all word blank answer based on request
    func fetchAnswersById<T>(request: AnswerRequest) async throws -> ([T], ErrorStatus) where T : SupabaseAnswer {
        do {
            guard request.questionId != nil || request.answerId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("WordBlankAnswer")
                .select()
            
            if let questionId = request.questionId {
                query = query
                    .eq("questionId", value: questionId)
            }
            
            if let answerId = request.answerId {
                query = query
                    .eq("answerId", value: answerId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseWordBlankAnswer].self)
            
            switch result {
            case .success(let page):
                guard page.isEmpty == false else {
                    return ([], .notFound)
                }
                if let castedPage = page as? [T] {
                    return (castedPage, .success)
                } else {
                    return ([], .jsonError)
                }
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
}

class SupabaseMultiChoiceAnswerRepository: SupabaseRepository, AnswerRepository {
    
    //singleton
    public static let shared = SupabaseMultiChoiceAnswerRepository()
    private override init() {}
    
    // fetch all multi choice answer
    func fetchAnswers() async throws -> ([SupabaseAnswer], ErrorStatus) {
        let response = try await client
            .from("MultiChoiceAnswer")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseMultiChoiceAnswer].self)
        
        switch result {
        case .success(let answers):
            guard answers.isEmpty == false else {
                return ([], .notFound)
            }
            return (answers, .success)
        case .failure(_):
            return ([], .jsonError)
        }
    }
    
    //Fetch all multi choice answer based on request
    func fetchAnswersById<T>(request: AnswerRequest) async throws -> ([T], ErrorStatus) where T : SupabaseAnswer {
        do {
            guard request.questionId != nil || request.answerId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("MultiChoiceAnswer")
                .select()
            
            if let questionId = request.questionId {
                query = query
                    .eq("questionId", value: questionId)
            }
            
            if let answerId = request.answerId {
                query = query
                    .eq("answerId", value: answerId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseMultiChoiceAnswer].self)
            
            switch result {
            case .success(let page):
                guard page.isEmpty == false else {
                    return ([], .notFound)
                }
                if let castedPage = page as? [T] {
                    return (castedPage, .success)
                } else {
                    return ([], .jsonError)
                }
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
}

class SupabaseWordMatchAnswerRepository: SupabaseRepository, AnswerRepository {
    
    //singleton
    public static let shared = SupabaseWordMatchAnswerRepository()
    private override init() {}
    
    // fetch all word match answers
    func fetchAnswers() async throws -> ([SupabaseAnswer], ErrorStatus) {
        let response = try await client
            .from("WordMatchAnswer")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseWordMatchAnswer].self)
        
        switch result {
        case .success(let answers):
            guard answers.isEmpty == false else {
                return ([], .notFound)
            }
            return (answers, .success)
        case .failure(_):
            return ([], .jsonError)
        }
    }
    
    //Fetch all word blank answer based on request
    func fetchAnswersById<T>(request: AnswerRequest) async throws -> ([T], ErrorStatus) where T : SupabaseAnswer {
        do {
            guard request.questionId != nil || request.answerId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("WordMatchAnswer")
                .select()
            
            if let questionId = request.questionId {
                query = query
                    .eq("questionId", value: questionId)
            }
            
            if let answerId = request.answerId {
                query = query
                    .eq("answerId", value: answerId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseWordMatchAnswer].self)
            
            switch result {
            case .success(let page):
                guard page.isEmpty == false else {
                    return ([], .notFound)
                }
                if let castedPage = page as? [T] {
                    return (castedPage, .success)
                } else {
                    return ([], .jsonError)
                }
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
}
