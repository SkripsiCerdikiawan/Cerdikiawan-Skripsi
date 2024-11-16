//
//  Character.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseCharacter: Codable {
    let CharacterID: UUID
    let CharacterImagePath: String
    let CharacterPrice: Int
    let CharacterDescription: String
}
