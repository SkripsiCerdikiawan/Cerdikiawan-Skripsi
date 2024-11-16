//
//  Attempt.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseAttempt: Codable {
    let attemptId: UUID
    let profileId: UUID
    let storyId: UUID
    let attemptDateTime: Date
    let kosakataPercentage: Float
    let idePokokPercentage: Float
    let implisitPercentage: Float
    let recordSoundPath: String
}
