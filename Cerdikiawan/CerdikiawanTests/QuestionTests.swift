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
    
    @Test func testFetchQuestions() async throws {
        let (questions, status) = try await questionRepository.fetchQuestions()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Questions should not be empty"
        )
    }
    
    @Test func testFetchQuestionsByQuestionId() async throws {
        let request = QuestionRequest(questionId: UUID(uuidString: "023e6f79-461f-42d4-bf9e-710833eb7639"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Question should not be empty"
        )
        
        #expect(questions.count == 1 &&
                questions.contains(where: { $0.questionId == request.questionId }),
                "Question should match the intended questionId"
        )
    }

    @Test func testFetchQuestionsByPageId() async throws {
        let request = QuestionRequest(pageId: UUID(uuidString: "4567c8a0-ef17-48ee-987e-03042b0effec"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!questions.isEmpty,
                "Question should not be empty"
        )
        
        #expect(questions.count == 3 &&
                questions.contains(where: { $0.pageId == request.pageId }),
                "Question should match the intended pageId"
        )
    }
    
    @Test func testFetchQuestionsUsingInvalidId() async throws {
        let request = QuestionRequest(questionId: UUID(uuidString: "wrong id"))
        let (questions, status) = try await questionRepository.fetchQuestionsById(request: request)
        
        #expect(questions.isEmpty &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
