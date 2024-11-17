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
        let profile = SupabaseProfile(profileId: request.profileId,
                                      profileName: request.profileName,
                                      profileBalance: request.profileBalance,
                                      profileBirthDate: request.profileBirthDate
        )
        
        do {
            let response = try await client
                .from("Profile")
                .insert(profile)
                .execute()
            
            guard response.status == 201 else {
                return (nil, .serverError)
            }
            
            return (profile, .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    func updateProfile(request: ProfileUpdateRequest) async throws -> (SupabaseProfile?, ErrorStatus) {
        return (nil, .notFound)
    }
    
    func deleteProfile(request: ProfileDeleteRequest) async throws -> (ErrorStatus) {
        return (.serverError)
    }    
}
