//
//  Character.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseCharacter: Codable {
    let characterId: UUID
    let characterName: String
    let characterImagePath: String
    let characterDescription: String
}
