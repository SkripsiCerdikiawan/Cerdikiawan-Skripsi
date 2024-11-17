//
//  ProfileOwnedCharacterRequest.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

struct ProfileOwnedCharacterFetchRequest {
    var profileId: UUID
    var characterId: UUID?
}

struct ProfileOwnedCharacterInsertRequest {
    var profileId: UUID
    var characterId: UUID
    let isChosen: Bool
}

struct ProfileOwnedCharacterUpdateRequest {
    var profileId: UUID
    var characterId: UUID
    let isChosen: Bool?
}
