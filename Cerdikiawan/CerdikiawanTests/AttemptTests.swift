//
//  AttemptTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct AttemptTests {
    var attemptRepository: AttemptRepository
    
    init() async throws {
        attemptRepository = SupabaseAttemptRepository.shared
    }
    
    @Test func testFetchAttempt() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptFetchRequest(profileId: profileId)
        let (attempts, status) = try await attemptRepository.fetchAttempts(request: request)
        
        #expect(status == .success, "Failed to fetch attempts")
        #expect(attempts.allSatisfy( { $0.profileId == request.profileId }), "Attempts fetched is wrong")
        #expect(attempts.count == 3, "Wrong number of attempts fetched")
    }
    
    @Test func testFetchAttemptWithStoryId() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptFetchRequest(profileId: profileId,
                                          storyId: UUID(uuidString: "ca5ad1b2-1b24-4136-9765-c6e69476fcf3"))
        let (attempts, status) = try await attemptRepository.fetchAttempts(request: request)
        
        #expect(status == .success, "Failed to fetch attempts")
        #expect(attempts.allSatisfy( { $0.profileId == request.profileId && $0.storyId == request.storyId }), "Attempts fetched is wrong")
        #expect(attempts.count == 2, "Wrong number of attempts fetched")
    }
    
    @Test func testFetchAttemptWithAttemptId() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptFetchRequest(attemptId: UUID(uuidString: "d6d1d27a-4d1c-45aa-978c-fd361d69aef2"),
                                          profileId: profileId
                                          )
        let (attempts, status) = try await attemptRepository.fetchAttempts(request: request)
        
        #expect(status == .success, "Failed to fetch attempts")
        #expect(attempts.allSatisfy( { $0.profileId == request.profileId && $0.attemptId == request.attemptId }), "Attempts fetched is wrong")
        #expect(attempts.count == 1, "Wrong number of attempts fetched")
    }
    
    @Test func fetchInvalidAttempt() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptFetchRequest(attemptId: UUID(uuidString: "c64226ab-a158-4040-abd2-0ee9ab465132"),
                                          profileId: profileId
                                          )
        let (attempts, status) = try await attemptRepository.fetchAttempts(request: request)
        
        #expect(status == .notFound, "There should be no attempt matching the request")
        #expect(attempts.isEmpty, "Attempt should be empty")
    }
    
    @Test func testInsertNewAttempt() async throws {
        guard let profileId = UUID(uuidString: "d7e08c6a-e80e-4288-9675-69dd454c14d8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        guard let storyId = UUID(uuidString: "ca5ad1b2-1b24-4136-9765-c6e69476fcf3") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptInsertRequest(attemptId: UUID(),
                                           profileId: profileId,
                                           storyId: storyId,
                                           attemptDateTime: Date.now.description,
                                           kosakataPercentage: 99.9,
                                           idePokokPercentage: 99,
                                           implisitPercentage: -1,
                                           recordSoundPath: "TestRecord"
        )
         
        let (attempt, status) = try await attemptRepository.createNewAttempt(request: request)
        
        #expect(status == .success, "Insert not successful")
        #expect(attempt != nil, "Attempt should not be empty")
    }
    
    @Test func testFailedInsertAttempt() async throws {
        guard let attemptId = UUID(uuidString: "88105578-d695-4fe9-94c9-a68aa39b929b") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        guard let profileId = UUID(uuidString: "d7e08c6a-e80e-4288-9675-69dd454c14d8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        guard let storyId = UUID(uuidString: "ca5ad1b2-1b24-4136-9765-c6e69476fcf3") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = AttemptInsertRequest(attemptId: attemptId,
                                           profileId: profileId,
                                           storyId: storyId,
                                           attemptDateTime: Date.now.description,
                                           kosakataPercentage: -1,
                                           idePokokPercentage: 80,
                                           implisitPercentage: -1,
                                           recordSoundPath: "TestRecord2"
        )
        
        let (attempt, status) = try await attemptRepository.createNewAttempt(request: request)
        
        #expect(status == .serverError, "Insert should not be successful")
        #expect(attempt == nil, "Attempt should be empty")
    }
}
