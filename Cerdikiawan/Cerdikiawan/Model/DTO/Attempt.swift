//
//  Attempt.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseAttempt: Codable {
    let AttemptID: UUID
    let ProfileID: UUID
    let StoryID: UUID
    let AttemptDateTime: Date
    let KosakataPercentage: Float
    let IdePokokPercentage: Float
    let ImplisitPercentage: Float
    let RecordSoundPath: String
}
