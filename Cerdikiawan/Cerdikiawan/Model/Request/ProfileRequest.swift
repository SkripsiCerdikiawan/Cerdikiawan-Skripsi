//
//  ProfileRequest.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol ProfileRequest {
    var profileId: UUID { get }
}

struct ProfileFetchRequest: ProfileRequest {
    let profileId: UUID
}

struct ProfileInsertRequest: ProfileRequest {
    let profileId: UUID
    var profileName: String
    var profileBalance: Int
    /// Format: yyyy-mm-dd
    var profileBirthDate: String
}

struct ProfileUpdateRequest: ProfileRequest {
    let profileId: UUID
    var profileName: String?
    var profileBalance: Int?
    /// Format: yyyy-mm-dd
    var profileBirthDate: String?
}

struct ProfileDeleteRequest: ProfileRequest {
    let profileId: UUID
}
