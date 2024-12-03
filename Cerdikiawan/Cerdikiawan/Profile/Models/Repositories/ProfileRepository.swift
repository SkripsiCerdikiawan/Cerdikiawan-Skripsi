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
        do {
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
        } catch {
            return (nil, .notFound)
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
        let (profile, status) = try await fetchProfile(request: ProfileFetchRequest(profileId: request.profileId))
        
        guard status == .success, let initialProfile = profile else {
            return (nil, .notFound)
        }
        
        guard request.profileName != nil || request.profileBalance != nil || request.profileBirthDate != nil else {
            return (profile, .invalidInput)
        }
        
        var savedProfile = initialProfile
        do {
            if let profileName = request.profileName, profileName != savedProfile.profileName {
                savedProfile = try await updateProfileData(updatedColumn: "profileName", updatedValue: profileName, profileId: request.profileId)
            }
            
            if let profileBalance = request.profileBalance, profileBalance != savedProfile.profileBalance {
                savedProfile = try await updateProfileData(updatedColumn: "profileBalance", updatedValue: profileBalance, profileId: request.profileId)
            }
            
            if let profileBirthDate = request.profileBirthDate, profileBirthDate != savedProfile.profileBirthDate {
                savedProfile = try await updateProfileData(updatedColumn: "profileBirthDate", updatedValue: profileBirthDate, profileId: request.profileId)
            }
            
            return (savedProfile, .success)
        } catch {
            return (savedProfile, .serverError)
        }
    }
    
    private func updateProfileData<T: Encodable>(updatedColumn: String, updatedValue: T, profileId: UUID) async throws -> SupabaseProfile {
        return try await client
            .from("Profile")
            .update([updatedColumn: updatedValue])
            .eq("profileId", value: profileId)
            .single()
            .execute()
            .value
    }
    
    func deleteProfile(request: ProfileDeleteRequest) async throws -> (ErrorStatus) {
        let (profile, status) = try await fetchProfile(request: ProfileFetchRequest(profileId: request.profileId))
        
        guard let toBeDeletedProfile = profile, status == .success else {
            return (.notFound)
        }
        
        do {
            let response = try await client
                .from("Profile")
                .delete()
                .eq("profileId", value: toBeDeletedProfile.profileId)
                .execute()
            guard response.status == 200 else {
                return (.serverError)
            }
            return (.success)
        } catch {
            return (.serverError)
        }
    }
}
