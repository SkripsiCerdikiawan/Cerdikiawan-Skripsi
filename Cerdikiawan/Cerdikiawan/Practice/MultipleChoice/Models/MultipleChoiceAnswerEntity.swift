//
//  MultipleChoiceAnswerEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct MultipleChoiceAnswerEntity {
    var id: String
    var content: String
}

extension MultipleChoiceAnswerEntity {
    static func mock() -> [MultipleChoiceAnswerEntity] {
        return [
            .init(
                id: "mc-answer-01",
                content: "Choice 1"
            ),
            .init(
                id: "mc-answer-02",
                content: "Choice 2"
            ),
            .init(
                id: "mc-answer-03",
                content: "Choice 3"
            ),
            .init(
                id: "mc-answer-04",
                content: "Choice 4"
            )
        ]
    }
}
