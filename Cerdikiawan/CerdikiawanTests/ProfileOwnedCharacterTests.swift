//
//  ProfileOwnedCharacterTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct ProfileOwnedCharacterTests {
    var profileOwnedCharacterRepository: ProfileOwnedCharacterRepository
    
    init() async throws {
        profileOwnedCharacterRepository = SupabaseProfileOwnedCharacterRepository.shared
    }
    
    @Test func fetchSpecificProfileOwnedCharacter() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileOwnedCharacterFetchRequest(profileId: profileId,
                                                        characterId: UUID(uuidString: "07532921-149d-431a-bc2e-0251d5b06afd")
        )
        
        let (ownedCharacter, status) = try await profileOwnedCharacterRepository.fetchProfileOwnedCharacter(request: request)
        
        #expect(status == .success, "Failed to fetch characters")
        #expect(ownedCharacter.contains(where: { $0.characterId == request.characterId &&
            $0.profileId == request.profileId
        }), "Character fetched is wrong")
    }
    
    @Test func fetchAllProfileOwnedCharacters() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileOwnedCharacterFetchRequest(profileId: profileId)
        
        let (ownedCharacter, status) = try await profileOwnedCharacterRepository.fetchProfileOwnedCharacter(request: request)
        
        #expect(status == .success, "Failed to fetch characters")
        #expect(ownedCharacter.contains(where: { $0.profileId == request.profileId && ownedCharacter.count == 2}), "Character did not get fetched")
    }
    
    @Test func insertProfileOwnedCharacter() async throws {
        guard let profileId = UUID(uuidString: "d7e08c6a-e80e-4288-9675-69dd454c14d8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        guard let characterId = UUID(uuidString: "07532921-149d-431a-bc2e-0251d5b06afd") else {
            #expect(Bool(false), "Invalid characterId")
            return
        }
        let request = ProfileOwnedCharacterInsertRequest(profileId: profileId,
                                                         characterId: characterId,
                                                         isChosen: false
        )
        let (ownedCharacter, status) = try await profileOwnedCharacterRepository.insertProfileOwnedCharacter(request: request)
        
        #expect(status == .success, "Failed to insert owned characters")
        #expect(ownedCharacter != nil, "Inserted owned character is nil")
    }
    
    @Test func updateProfileOwnedCharacter() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        guard let characterId = UUID(uuidString: "07532921-149d-431a-bc2e-0251d5b06afd") else {
            #expect(Bool(false), "Invalid characterId")
            return
        }
        
        let request = ProfileOwnedCharacterUpdateRequest(profileId: profileId,
                                                         characterId: characterId,
                                                         isChosen: true
        )
        
        let (ownedCharacter, status) = try await profileOwnedCharacterRepository.updateProfileOwnedCharacter(request: request)
        
        #expect(status == .success, "Failed to insert owned characters")
        #expect(ownedCharacter != nil, "Inserted owned character is nil")
        
        if let character = ownedCharacter {
            #expect(character.isChosen == request.isChosen, "Invalid isChosen value")
        }
    }
}
