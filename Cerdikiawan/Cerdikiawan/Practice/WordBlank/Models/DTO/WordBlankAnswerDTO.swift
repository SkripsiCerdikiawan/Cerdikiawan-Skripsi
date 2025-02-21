//
//  WordBlankAnswer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseWordBlankAnswer: SupabaseAnswer {
    let answerId: UUID
    let questionId: UUID
    let answerContent: String
}
