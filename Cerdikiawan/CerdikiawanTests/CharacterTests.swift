//
//  CharacterTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct CharacterTests {
    var characterRepository: CharacterRepository
    
    init() async throws {
        characterRepository = SupabaseCharacterRepository.shared
    }
    
    @Test func testFetchCharacters() async throws {
        //TODO: Add auth process
        let (characters, status) = try await characterRepository.fetchCharacters()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!characters.isEmpty,
                "Characters should not be empty"
        )
    }
    
    @Test func testFetchCharacterById() async throws {
        //TODO: Add auth process
        let request = CharacterRequest(characterId: UUID(uuidString: "07532921-149d-431a-bc2e-0251d5b06afd"))
        let (character, status) = try await characterRepository.fetchCharacterById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(character != nil,
                "Character should be fetched"
        )
        
        #expect(character?.characterId == request.characterId,
                "characterId does not match"
        )
    }
    
    @Test func testFetchInvalidCharacterId() async throws {
        let request = CharacterRequest(characterId: UUID(uuidString: "wrong id"))
        let (story, status) = try await characterRepository.fetchCharacterById(request: request)
        
        #expect(story == nil &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
    
    @Test func testFetchCharacterByName() async throws {
        let request = CharacterNameRequest(characterName: "Budi")
        let (character, status) = try await characterRepository.fetchCharacterByName(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(character != nil,
                "Character should be fetched"
        )
        
        #expect(character?.characterName == request.characterName,
                "characterId does not match"
        )
    }
}
