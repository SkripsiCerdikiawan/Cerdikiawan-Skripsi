//
//  Question.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseQuestion: Codable {
    let QuestionID: UUID
    let PageID: UUID
    let QuestionType: String
    let QuestionCategory: String
    let QuestionContent: String
    let QuestionFeedbackIfTrue: String
    let QuestionFeedbackIfFalse: String
    let QuestionPointGain: Int
}
