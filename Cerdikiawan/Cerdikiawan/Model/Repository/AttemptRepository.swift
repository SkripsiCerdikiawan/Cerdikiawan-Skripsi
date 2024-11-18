//
//  AttemptRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol AttemptRepository {
    func fetchAttempts(request: AttemptFetchRequest) async throws -> ([SupabaseAttempt], ErrorStatus)
    func createNewAttempt(request: AttemptInsertRequest) async throws -> (SupabaseAttempt?, ErrorStatus)
}

class SupabaseAttemptRepository: SupabaseRepository, AttemptRepository {
    
    public static let shared = SupabaseAttemptRepository()
    private override init() {}
    
    func fetchAttempts(request: AttemptFetchRequest) async throws -> ([SupabaseAttempt], ErrorStatus) {
        do {
            var query = client
                .from("Attempt")
                .select()
                .eq("profileId", value: request.profileId)
            
            if let attemptId = request.attemptId {
                query = query.eq("attemptId", value: attemptId)
            }
            
            if let storyId = request.storyId {
                query = query.eq("storyId", value: storyId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseAttempt].self)
            
            switch result {
            case .success(let attempt):
                guard attempt.isEmpty == false else {
                    return ([], .notFound)
                }
                return (attempt, .success)
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
    
    func createNewAttempt(request: AttemptInsertRequest) async throws -> (SupabaseAttempt?, ErrorStatus) {
        let attempt = SupabaseAttempt(attemptId: request.attemptId,
                                      profileId: request.profileId,
                                      storyId: request.storyId,
                                      attemptDateTime: request.attemptDateTime,
                                      kosakataPercentage: request.kosakataPercentage,
                                      idePokokPercentage: request.idePokokPercentage,
                                      implisitPercentage: request.implisitPercentage,
                                      recordSoundPath: request.recordSoundPath
        )
        
        do {
            let response = try await client
                .from("Attempt")
                .insert(attempt)
                .execute()
            
            guard response.status == 201 else {
                return (nil, .serverError)
            }
            
            return (attempt, .success)
        } catch {
            return (nil, .serverError)
        }
    }
}
