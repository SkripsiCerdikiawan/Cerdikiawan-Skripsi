//
//  WordMatchAnswer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseWordMatchAnswer: SupabaseAnswer {
    let answerId: UUID
    let questionId: UUID
    let questionPrompt: String
    let answerPrompt: String
}
