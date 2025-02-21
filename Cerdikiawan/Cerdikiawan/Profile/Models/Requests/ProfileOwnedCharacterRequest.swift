//
//  ProfileOwnedCharacterRequest.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol ProfileOwnedCharacterRequest {
    var profileId: UUID { get }
}

struct ProfileOwnedCharacterFetchRequest: ProfileOwnedCharacterRequest {
    var profileId: UUID
    var characterId: UUID?
}

struct ProfileOwnedCharacterInsertRequest: ProfileOwnedCharacterRequest {
    var profileId: UUID
    var characterId: UUID
    let isChosen: Bool
}

struct ProfileOwnedCharacterUpdateRequest: ProfileOwnedCharacterRequest {
    var profileId: UUID
    var characterId: UUID
    let isChosen: Bool?
}
