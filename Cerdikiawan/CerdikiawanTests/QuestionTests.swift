//
//  QuestionTest.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct QuestionTests {
    var questionRepository: QuestionRepository
    
    init() async throws {
        questionRepository = SupabaseQuestionRepository.shared
    }
    
    @Test func fetchQuestions() async throws {
        //TODO: Add auth process
        let (questions, status) = try await questionRepository.fetchQuestions()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Questions should not be empty"
        )
    }
    
    @Test func fetchQuestionsByQuestionId() async throws {
        let request = QuestionRequest(questionId: UUID(uuidString: "d0e1622e-d118-423a-b47b-e41c2ada775b"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Page should not be empty"
        )
        
        #expect(questions.count == 1 &&
                questions.contains(where: { $0.questionId == request.questionId }),
                "Page should match the intended pageId"
        )
    }

    @Test func fetchQuestionsByPageId() async throws {
        let request = QuestionRequest(pageId: UUID(uuidString: "ae244295-e2cc-4279-a32e-e3f3e034a05c"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Page should not be empty"
        )
        
        #expect(questions.count == 2 &&
                questions.contains(where: { $0.pageId == request.pageId }),
                "Page should match the intended pageId"
        )
    }
    
    @Test func fetchQuestionsUsingInvalidId() async throws {
        let request = QuestionRequest(questionId: UUID(uuidString: "wrong id"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(questions.isEmpty &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
