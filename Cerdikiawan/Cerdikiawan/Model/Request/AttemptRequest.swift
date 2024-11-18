//
//  AttemptRequest.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation


protocol AttemptRequest {
    var profileId: UUID { get }
}

struct AttemptFetchRequest: AttemptRequest {
    var attemptId: UUID?
    var profileId: UUID
    var storyId: UUID?
}

struct AttemptInsertRequest: AttemptRequest {
    let attemptId: UUID
    let profileId: UUID
    let storyId: UUID
    let attemptDateTime: String
    let kosakataPercentage: Float
    let idePokokPercentage: Float
    let implisitPercentage: Float
    let recordSoundPath: String
}


