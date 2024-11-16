//
//  Profile.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseProfile: Codable {
    let ProfileID: UUID
    let ProfileName: String
    let ProfileBalance: Int
    let ProfileBirthDate: Date
}
