//
//  ProfileOwnedCharacterRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol ProfileOwnedCharacterRepository {
    func fetchProfileOwnedCharacter(request: ProfileOwnedCharacterFetchRequest) async throws -> ([SupabaseProfileOwnedCharacter], ErrorStatus)
    func insertProfileOwnedCharacter(request: ProfileOwnedCharacterInsertRequest) async throws -> (SupabaseProfileOwnedCharacter?, ErrorStatus)
    func updateProfileOwnedCharacter(request: ProfileOwnedCharacterUpdateRequest) async throws -> (SupabaseProfileOwnedCharacter?, ErrorStatus)
}

class SupabaseProfileOwnedCharacterRepository: SupabaseRepository, ProfileOwnedCharacterRepository {
    
    // singleton
    public static let shared = SupabaseProfileOwnedCharacterRepository()
    private override init() {}
    
    // fetch all character that the user owns
    func fetchProfileOwnedCharacter(request: ProfileOwnedCharacterFetchRequest) async throws -> ([SupabaseProfileOwnedCharacter], ErrorStatus) {
        
        do {
            var query = client
                .from("ProfileOwnedCharacter")
                .select()
                .eq("profileId", value: request.profileId)
            
            if let characterId = request.characterId {
                query = query.eq("characterId", value: characterId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return ([], .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseProfileOwnedCharacter].self)
            
            switch result {
            case .success(let ownedCharacters):
                guard ownedCharacters.isEmpty == false else {
                    return ([], .notFound)
                }
                return (ownedCharacters, .success)
            case .failure(_):
                return ([], .jsonError)
            }
        } catch {
            return ([], .notFound)
        }
    }
    
    // insert add new character into user profile
    func insertProfileOwnedCharacter(request: ProfileOwnedCharacterInsertRequest) async throws -> (SupabaseProfileOwnedCharacter?, ErrorStatus) {
        let ownedCharacter = SupabaseProfileOwnedCharacter(profileId: request.profileId,
                                                           characterId: request.characterId,
                                                           isChosen: request.isChosen
        )
        
        do {
            let response = try await client
                .from("ProfileOwnedCharacter")
                .insert(ownedCharacter)
                .execute()
            
            guard response.status == 201 else {
                return (nil, .serverError)
            }
            
            return (ownedCharacter, .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    // update the profile information (generally its about the currently equipped character
    func updateProfileOwnedCharacter(request: ProfileOwnedCharacterUpdateRequest) async throws -> (SupabaseProfileOwnedCharacter?, ErrorStatus) {
        // get the requested character
        let (ownedCharacter, status) = try await fetchProfileOwnedCharacter(request:
                                                                                ProfileOwnedCharacterFetchRequest(profileId: request.profileId,
                                                                                                                  characterId: request.characterId
                                                                                                                 )
        )
        
        guard status == .success, let initialOwnedCharacter = ownedCharacter.first else {
            return (nil, .notFound)
        }
        
        guard request.isChosen != nil else {
            return (ownedCharacter.first, .invalidInput)
        }
        
        var savedCharacter = initialOwnedCharacter
        do {
            // update the isChosen property of the character
            if let isChosen = request.isChosen, isChosen != savedCharacter.isChosen {
                savedCharacter = try await updateOwnedCharacterData(updatedColumn: "isChosen", updatedValue: isChosen, profileId: request.profileId, characterId: request.characterId)
            }
            
            return (savedCharacter, .success)
        } catch {
            return (savedCharacter, .serverError)
        }
    }
    
    //function to update certain property into profileOwnedCharacter
    private func updateOwnedCharacterData<T: Encodable>(updatedColumn: String, updatedValue: T, profileId: UUID, characterId: UUID) async throws -> SupabaseProfileOwnedCharacter {
        return try await client
            .from("ProfileOwnedCharacter")
            .update([updatedColumn: updatedValue])
            .eq("profileId", value: profileId)
            .eq("characterId", value: characterId)
            .single()
            .execute()
            .value
    }
}
