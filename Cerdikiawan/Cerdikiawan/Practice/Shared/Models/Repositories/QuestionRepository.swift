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
        let (questions, status) = try await fetchQuestions()
        
        guard status == .success else {
            return ([], .serverError)
        }
        
        guard request.questionId != nil || request.pageId != nil else {
            return ([], .invalidInput)
        }
        
        var sortedQuestions = questions
        
        if let questionId = request.questionId {
            sortedQuestions = sortedQuestions.filter( {$0.questionId == questionId} )
        }
        
        if let pageId = request.pageId {
            sortedQuestions = sortedQuestions.filter( {$0.pageId == pageId} )
        }
        
        guard !sortedQuestions.isEmpty else {
            return ([], .notFound)
        }
        
        return (sortedQuestions, .success)
    }
    
    
}
