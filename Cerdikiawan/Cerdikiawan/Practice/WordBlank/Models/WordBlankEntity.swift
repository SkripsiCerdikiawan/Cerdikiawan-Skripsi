//
//  WordBlankEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 18/11/24.
//

import Foundation

struct WordBlankEntity: QuestionProtocol {
    var id: String
    var question: String
    var correctAnswerWord: String
    var letters: [WordBlankLetterEntity]
    var feedback: FeedbackEntity
}

extension WordBlankEntity {
    static func mock() -> [WordBlankEntity] {
        return [
            .init(
                id: "wb-ques-01",
                question: "This is a question example, Do you understand?",
                correctAnswerWord: "WORD",
                letters: [
                    .init(id: "wb-char-1", letter: "C"),
                    .init(id: "wb-char-2", letter: "W"),
                    .init(id: "wb-char-3", letter: "D"),
                    .init(id: "wb-char-4", letter: "A"),
                    .init(id: "wb-char-5", letter: "O"),
                    .init(id: "wb-char-6", letter: "R"),
                ],
                feedback: .mock()[0]
            )
        ]
    }
}

