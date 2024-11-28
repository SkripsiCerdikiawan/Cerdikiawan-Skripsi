//
//  ProfileOwnedCharacter.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseProfileOwnedCharacter: Codable {
    let profileId: UUID
    let characterId: UUID
    let isChosen: Bool
}
