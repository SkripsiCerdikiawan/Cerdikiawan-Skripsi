//
//  WordMatchAnswer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseWordMatchAnswer: Codable {
    let AnswerID: UUID
    let QuestionID: UUID
    let QuestionPrompt: String
    let AnswerPrompt: String
}
