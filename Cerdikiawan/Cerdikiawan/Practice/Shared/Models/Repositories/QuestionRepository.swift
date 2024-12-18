//
//  QuestionRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol QuestionRepository {
    func fetchQuestions() async throws -> ([SupabaseQuestion], ErrorStatus)
    func fetchQuestionsById(request: QuestionRequest) async throws -> ([SupabaseQuestion], ErrorStatus)
}

class SupabaseQuestionRepository: SupabaseRepository, QuestionRepository {
    
    public static let shared = SupabaseQuestionRepository()
    private override init() {}
    
    func fetchQuestions() async throws -> ([SupabaseQuestion], ErrorStatus) {
        let response = try await client
            .from("Question")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseQuestion].self)
        
        switch result {
        case .success(let questions):
            guard questions.isEmpty == false else {
                return ([], .notFound)
            }
            return (questions, .success)
        case .failure(_):
            return ([], .jsonError)
        }
    }
    
    func fetchQuestionsById(request: QuestionRequest) async throws -> ([SupabaseQuestion], ErrorStatus) {
        do {
            guard request.questionId != nil || request.pageId != nil else {
                return ([], .invalidInput)
            }
            
            var query = client
                .from("Question")
                .select()
            
            if let questionId = request.questionId {
                query = query
                    .eq("questionId", value: questionId)
            }
            
            if let pageId = request.pageId {
                query = query
                    .eq("pageId", value: pageId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseQuestion].self)
            
            switch result {
            case .success(let question):
                guard question.isEmpty == false else {
                    return ([], .notFound)
                }
                return (question, .success)
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
    
    
}
