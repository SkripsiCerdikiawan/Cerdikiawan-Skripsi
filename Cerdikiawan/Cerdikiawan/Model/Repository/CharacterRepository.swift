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
    
    public static let shared = SupabaseCharacterRepository()
    private override init() {}
    
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
                return (characters, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    func fetchCharacterById(request: CharacterRequest) async throws -> (SupabaseCharacter?, ErrorStatus) {
        let (characters, status) = try await fetchCharacters()
        
        if let characterId = request.characterId {
            guard status == .success else {
                return (nil, .serverError)
            }
            guard let character = characters.first(where: {$0.characterId == characterId} ) else {
                return (nil, .notFound)
            }
            return (character, .success)
        } else {
            return (nil, .invalidInput)
        }
    }
    
    
}
