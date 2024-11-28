//
//  Question.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseQuestion: Codable {
    let questionId: UUID
    let pageId: UUID
    let questionType: String
    let questionCategory: String
    let questionContent: String
    let questionFeedbackIfTrue: String
    let questionFeedbackIfFalse: String
    let questionPointGain: Int
}
