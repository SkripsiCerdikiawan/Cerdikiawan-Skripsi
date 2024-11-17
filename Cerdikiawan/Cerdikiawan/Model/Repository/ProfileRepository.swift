//
//  ProfileRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol ProfileRepository {
    func fetchProfile(request: ProfileFetchRequest) async throws -> (SupabaseProfile?, ErrorStatus)
    func createNewProfile(request: ProfileInsertRequest) async throws -> (SupabaseProfile?, ErrorStatus)
    func updateProfile(request: ProfileUpdateRequest) async throws -> (SupabaseProfile?, ErrorStatus)
    func deleteProfile(request: ProfileDeleteRequest) async throws -> (ErrorStatus)
}

class SupabaseProfileRepository: SupabaseRepository, ProfileRepository {
    
    public static let shared = SupabaseProfileRepository()
    private override init() {}
    
    func fetchProfile(request: ProfileFetchRequest) async throws -> (SupabaseProfile?, ErrorStatus) {
        let response = try await client
            .from("Profile")
            .select()
            .eq("profileId", value: request.profileId)
            .single()
            .execute()
        
        guard response.status == 200 else {
            return (nil, .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: SupabaseProfile.self)
        
        switch result {
            case .success(let profile):
            return (profile, .success)
            case .failure(_):
                return (nil, .jsonError)
        }
    }
    
    func createNewProfile(request: ProfileInsertRequest) async throws -> (SupabaseProfile?, ErrorStatus) {
        return (nil, .notFound)
    }
    
    func updateProfile(request: ProfileUpdateRequest) async throws -> (SupabaseProfile?, ErrorStatus) {
        return (nil, .notFound)
    }
    
    func deleteProfile(request: ProfileDeleteRequest) async throws -> (ErrorStatus) {
        return (.serverError)
    }    
}
