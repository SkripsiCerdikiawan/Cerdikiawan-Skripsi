//
//  SoundRequest.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 21/11/24.
//

import Foundation

struct RecordSoundRequest {
    let userId: UUID
    let attemptId: UUID
    let soundData: Data
}
