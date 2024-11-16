//
//  MultiChoiceAnswer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseMultiChoiceAnswer: Codable {
    let answerId: UUID
    let questionId: UUID
    let answerContent: String
    let answerStatus: Bool
}
