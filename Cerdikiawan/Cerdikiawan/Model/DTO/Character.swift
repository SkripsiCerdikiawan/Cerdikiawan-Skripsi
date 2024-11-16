//
//  Character.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseCharacter: Codable {
    let characterId: UUID
    let characterImagePath: String
    let characterPrice: Int
    let characterDescription: String
}
