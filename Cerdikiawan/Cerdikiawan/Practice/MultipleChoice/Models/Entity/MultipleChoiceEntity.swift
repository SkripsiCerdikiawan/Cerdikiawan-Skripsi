//
//  MultipleChoiceEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct MultipleChoiceEntity: QuestionProtocol {
    var id: String
    var question: String
    var answer: [MultipleChoiceAnswerEntity]
    var correctAnswerID: String
    var type: QuestionType
    var feedback: FeedbackEntity
}

extension MultipleChoiceEntity {
    static func mock() -> [Self] {
        return [
            .init(
                id: "mc-ques-01",
                question: "This is an Example Question. Do you understand?",
                answer: MultipleChoiceAnswerEntity.mock(),
                correctAnswerID: "mc-answer-01",
                type: .idePokok,
                feedback: .mock()[0]
            ),
            .init(
                id: "mc-ques-02",
                question: "This is an Example Question. Do you understand?",
                answer: MultipleChoiceAnswerEntity.mock(),
                correctAnswerID: "mc-answer-01",
                type: .idePokok,
                feedback: .mock()[1]
            ),
        ]
    }
}
