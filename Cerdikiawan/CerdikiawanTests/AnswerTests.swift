//
//  AnswerTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct AnswerTests {
    var wordBlankAnswerRepository: AnswerRepository
    var multiChoiceAnswerRepository: AnswerRepository
    var wordMatchAnswerRepository: AnswerRepository
    
    var questionRepository: QuestionRepository
    
    init() async throws {
        wordBlankAnswerRepository = SupabaseWordBlankAnswerRepository.shared
        multiChoiceAnswerRepository = SupabaseMultiChoiceAnswerRepository.shared
        wordMatchAnswerRepository = SupabaseWordMatchAnswerRepository.shared
        
        questionRepository = SupabaseQuestionRepository.shared
    }
    
    @Test func testFetchWordBlankAnswers() async throws {
        let (answers, status) = try await wordBlankAnswerRepository.fetchAnswers()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answers should not be empty"
        )
    }
    
    @Test func testFetchMultiChoiceAnswers() async throws {
        let (answers, status) = try await multiChoiceAnswerRepository.fetchAnswers()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answers should not be empty"
        )
    }
    
    @Test func testFetchWordMatchAnswers() async throws {
        let (answers, status) = try await wordMatchAnswerRepository.fetchAnswers()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answers should not be empty"
        )
    }
    
    @Test func testFetchWordMatchAnswersByQuestionId() async throws {
        let request = AnswerRequest(questionId: UUID(uuidString: "1948f888-ab76-45b4-90ad-b32b264b3a28"))
        
        let (wordBlankAnswer, wordBlankStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: request)
        #expect(wordBlankStatus != .success && wordBlankAnswer.isEmpty, "There should be no word match answer found in word blank table")
        
        let (multiChoiceAnswer, multiChoiceStatus): ([SupabaseMultiChoiceAnswer], ErrorStatus) = try await multiChoiceAnswerRepository.fetchAnswersById(request: request)
        #expect(multiChoiceStatus != .success && multiChoiceAnswer.isEmpty, "There should be no word match answer found in multi choice table")
        
        let (answers, status): ([SupabaseWordMatchAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answer should not be empty"
        )
        
        #expect(answers.count == 4 &&
                answers.contains(where: { $0.questionId == request.questionId }),
                "Answer should match the intended questionId"
        )
    }
    
    @Test func testFetchWordBlankAnswersByQuestionId() async throws {
        let request = AnswerRequest(questionId: UUID(uuidString: "d0e1622e-d118-423a-b47b-e41c2ada775b"))
        
        let (wordMatchAnswer, wordMatchStatus): ([SupabaseWordMatchAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: request)
        #expect(wordMatchStatus != .success && wordMatchAnswer.isEmpty, "There should be no word blank answer found in word match table")
        
        let (multiChoiceAnswer, multiChoiceStatus): ([SupabaseMultiChoiceAnswer], ErrorStatus) = try await multiChoiceAnswerRepository.fetchAnswersById(request: request)
        #expect(multiChoiceStatus != .success && multiChoiceAnswer.isEmpty, "There should be no word blank answer found in multi choice table")
        
        let (answers, status): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answer should not be empty"
        )
        
        #expect(answers.count == 1 &&
                answers.contains(where: { $0.questionId == request.questionId }),
                "Answer should match the intended questionId"
        )
    }
    
    @Test func testFetchMultiChoiceAnswersByQuestionId() async throws {
        let request = AnswerRequest(questionId: UUID(uuidString: "c41bcd9e-9ae4-4fbf-964f-92dcd93b2113"))
        
        let (wordMatchAnswer, wordMatchStatus): ([SupabaseWordMatchAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: request)
        #expect(wordMatchStatus != .success && wordMatchAnswer.isEmpty, "There should be no multi choice answer found in word match table")
        
        let (wordBlankAnswers, wordBlankStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: request)
        #expect(wordBlankStatus != .success && wordBlankAnswers.isEmpty, "There should be no multi choice answer found in word blank table")
        
        let (answers, status): ([SupabaseMultiChoiceAnswer], ErrorStatus) = try await multiChoiceAnswerRepository.fetchAnswersById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!answers.isEmpty,
                "Answer should not be empty"
        )
        
        #expect(answers.count == 4 &&
                answers.contains(where: { $0.questionId == request.questionId }),
                "Answer should match the intended questionId"
        )
    }
    
    @Test func testDeterminingAnswersBasedOnStoryId() async throws {
        let questionRequest = QuestionRequest(questionId: UUID(uuidString: "b0098289-4617-4c69-9591-ec60a250e36b"))
        let (questions, questionStatus) = try await questionRepository.fetchQuestionsById(request: questionRequest)
        
        #expect(questionStatus == .success, "Failed to fetch questions")
        
        if let question = questions.first(where: { $0.questionId == questionRequest.questionId}) {
            
            let answerRequest = AnswerRequest(questionId: question.questionId)
            
            if question.questionType == "WordBlank" {
                let (answers, answerStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: answerRequest)
                validateAnswers(answers: answers, answerStatus: answerStatus, expectedQuestionId: answerRequest.questionId)
            } else if question.questionType == "MultiChoice" {
                let (answers, answerStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await multiChoiceAnswerRepository.fetchAnswersById(request: answerRequest)
                validateAnswers(answers: answers, answerStatus: answerStatus, expectedQuestionId: answerRequest.questionId)
            } else if question.questionType == "WordMatch" {
                let (answers, answerStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: answerRequest)
                validateAnswers(answers: answers, answerStatus: answerStatus, expectedQuestionId: answerRequest.questionId)
            } else {
                #expect(Bool(false), "Invalid question type")
            }
            
        } else {
            #expect(Bool(false), "No question found with the given id")
        }
    }
    
    private func validateAnswers<T: SupabaseAnswer>(answers: [T], answerStatus: ErrorStatus, expectedQuestionId: UUID?) {
        #expect(answerStatus == .success, "Failed to fetch answers")
        #expect(!answers.isEmpty, "No answers found for the given question id")
        #expect(answers.count == 1 && answers.allSatisfy({ $0.questionId == expectedQuestionId }), "Answer is not for the given question id")
    }
    
    @Test func testFetchAnswersByInvalidId() async throws {
        let request = AnswerRequest(answerId: UUID(uuidString: "wrong id"))
        
        let (multiChoiceAnswer, multiChoiceStatus): ([SupabaseMultiChoiceAnswer], ErrorStatus) = try await multiChoiceAnswerRepository.fetchAnswersById(request: request)
        
        #expect(multiChoiceAnswer.isEmpty &&
                multiChoiceStatus == .invalidInput,
                "Input must be invalid"
        )
        
        let (wordBlankAnswer, wordBlankStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: request)
        
        #expect(wordBlankAnswer.isEmpty &&
                wordBlankStatus == .invalidInput,
                "Input must be invalid"
        )
        
        let (wordMatchAnswer, wordMatchStatus): ([SupabaseWordMatchAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: request)
        
        #expect(wordMatchAnswer.isEmpty &&
                wordMatchStatus == .invalidInput,
                "Input must be invalid"
        )
    }

}
