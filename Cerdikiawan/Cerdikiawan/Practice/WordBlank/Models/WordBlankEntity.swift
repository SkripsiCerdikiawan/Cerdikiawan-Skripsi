//
//  WordBlankEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 18/11/24.
//

import Foundation

struct WordBlankEntity {
    var id: String
    var question: String
    var correctAnswerWord: String
    var characters: [WordBlankCharacterEntity]
}

extension WordBlankEntity {
    static func mock() -> [WordBlankEntity] {
        return [
            .init(
                id: "wb-ques-01",
                question: "This is a question example, Do you understand?",
                correctAnswerWord: "WORD",
                characters: [
                    .init(id: "wb-char-1", character: "C"),
                    .init(id: "wb-char-2", character: "W"),
                    .init(id: "wb-char-3", character: "D"),
                    .init(id: "wb-char-4", character: "A"),
                    .init(id: "wb-char-5", character: "O"),
                    .init(id: "wb-char-6", character: "R"),
                ]
            )
        ]
    }
}

