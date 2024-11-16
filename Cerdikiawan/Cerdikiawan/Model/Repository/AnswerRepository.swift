//
//  AnswerRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol AnswerRepository {
    func fetchAnswers() async throws -> ([SupabaseAnswer], ErrorStatus)
    func fetchAnswersById(request: AnswerRequest) async throws -> ([SupabaseAnswer], ErrorStatus)
}

internal class SupabaseAnswerRepository: SupabaseRepository, AnswerRepository {
    
    internal override init() {}
    
    func fetchAnswers() async throws -> ([any SupabaseAnswer], ErrorStatus) {
        fatalError("This method must be overridden by subclasses")
    }
    
    
    func fetchAnswersById(request: AnswerRequest) async throws -> ([any SupabaseAnswer], ErrorStatus) {
        let (answers, status) = try await fetchAnswers()
        
        guard status == .success else {
            return ([], .serverError)
        }
        
        guard request.questionId != nil || request.answerId != nil else {
            return ([], .invalidInput)
        }
        
        var sortedAnswers = answers
        
        if let questionId = request.questionId {
            sortedAnswers = sortedAnswers.filter( {$0.questionId == questionId} )
        }
        
        if let answerId = request.answerId {
            sortedAnswers = sortedAnswers.filter( {$0.answerId == answerId} )
        }
        
        guard !sortedAnswers.isEmpty else {
            return ([], .notFound)
        }
        
        return (sortedAnswers, .success)
    }
}

class SupabaseWordBlankAnswerRepository: SupabaseAnswerRepository {
    
    public static let shared = SupabaseWordBlankAnswerRepository()
    private override init() {}
    
    override func fetchAnswers() async throws -> ([any SupabaseAnswer], ErrorStatus) {
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
                return (answers, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
}

class SupabaseMultiChoiceAnswerRepository: SupabaseAnswerRepository {
    
    public static let shared = SupabaseMultiChoiceAnswerRepository()
    private override init() {}
    
    override func fetchAnswers() async throws -> ([any SupabaseAnswer], ErrorStatus) {
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
                return (answers, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
}

class SupabaseWordMatchAnswerRepository: SupabaseAnswerRepository {
    
    public static let shared = SupabaseWordMatchAnswerRepository()
    private override init() {}
    
    override func fetchAnswers() async throws -> ([any SupabaseAnswer], ErrorStatus) {
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
                return (answers, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
}
