//
//  MultiChoiceAnswer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseMultiChoiceAnswer: Codable {
    let AnswerID: UUID
    let QuestionID: UUID
    let AnswerContent: String
    let AnswerStatus: Bool
}
