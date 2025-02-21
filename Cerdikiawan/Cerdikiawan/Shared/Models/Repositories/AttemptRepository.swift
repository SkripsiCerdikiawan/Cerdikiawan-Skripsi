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
    
    //singleton
    public static let shared = SupabaseAttemptRepository()
    private override init() {}
    
    // fetch all attempts based on request (profileId is mandatory)
    func fetchAttempts(request: AttemptFetchRequest) async throws -> ([SupabaseAttempt], ErrorStatus) {
        do {
            // build query here
            var query = client
                .from("Attempt")
                .select()
                .eq("profileId", value: request.profileId)
            
            //filter query based on attemptId
            if let attemptId = request.attemptId {
                query = query.eq("attemptId", value: attemptId)
            }
            
            //filter query based on storyId
            if let storyId = request.storyId {
                query = query.eq("storyId", value: storyId)
            }
            
            //execute query
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            // parse query Data into the appropriate data model
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
    
    // make new attempt
    func createNewAttempt(request: AttemptInsertRequest) async throws -> (SupabaseAttempt?, ErrorStatus) {
        //make new data model object
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
            // pass data model object to query
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
