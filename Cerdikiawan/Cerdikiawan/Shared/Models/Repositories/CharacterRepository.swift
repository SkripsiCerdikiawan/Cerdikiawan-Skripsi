//
//  CharacterRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol CharacterRepository {
    func fetchCharacters() async throws -> ([SupabaseCharacter], ErrorStatus)
    func fetchCharacterById(request: CharacterRequest) async throws -> (SupabaseCharacter?, ErrorStatus)
}

class SupabaseCharacterRepository: SupabaseRepository, CharacterRepository {
    
    //singleton
    public static let shared = SupabaseCharacterRepository()
    private override init() {}
    
    //fetch all available character
    func fetchCharacters() async throws -> ([SupabaseCharacter], ErrorStatus) {
        let response = try await client
            .from("Character")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
        
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseCharacter].self)
        
        switch result {
        case .success(let characters):
            guard characters.isEmpty == false else {
                return ([], .notFound)
            }
            return (characters, .success)
        case .failure(_):
            return ([], .jsonError)
        }
    }
    
    //fetch character based on request
    func fetchCharacterById(request: CharacterRequest) async throws -> (SupabaseCharacter?, ErrorStatus) {
        do {
            guard request.characterId != nil || request.characterName != nil else {
                return (nil, .invalidInput)
            }
            
            var query = client
                .from("Character")
                .select()
            
            if let characterId = request.characterId {
                query = query
                    .eq("characterId", value: characterId)
            }
            
            if let characterName = request.characterName {
                query = query
                    .eq("characterName", value: characterName)
            }
            
            let response = try await query
                .limit(1)
                .execute()
            
            guard response.status == 200 else {
                return (nil, .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseCharacter].self)
            
            switch result {
            case .success(let character):
                return (character.first, .success)
            case .failure(_):
                return (nil, .jsonError)
            }
        } catch {
            return (nil, .notFound)
        }
    }
}
