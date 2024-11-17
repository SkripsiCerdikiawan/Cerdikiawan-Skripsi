//
//  Profile.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseProfile: Codable {
    let profileId: UUID
    let profileName: String
    let profileBalance: Int
    let profileBirthDate: String // Format: yyyy-mm-dd
}
