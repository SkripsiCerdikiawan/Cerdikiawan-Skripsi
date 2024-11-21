//
//  MultipleChoiceEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct MultipleChoiceEntity {
    var id: String
    var question: String
    var answer: [MultipleChoiceAnswerEntity]
    var correctAnswerID: String
    var correctFeedback: String
    var incorrectFeedback: String
}

extension MultipleChoiceEntity {
    static func mock() -> [Self] {
        return [
            .init(
                id: "mc-ques-01",
                question: "This is an Example Question. Do you understand?",
                answer: MultipleChoiceAnswerEntity.mock(),
                correctAnswerID: "mc-answer-01",
                correctFeedback: "Wow! Jawaban kamu benar!",
                incorrectFeedback: "Hmm.. Jawabanmu kurang tepat..."
            )
        ]
    }
}
