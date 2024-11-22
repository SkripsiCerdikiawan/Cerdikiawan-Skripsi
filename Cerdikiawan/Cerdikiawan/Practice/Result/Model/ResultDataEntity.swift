//
//  ResultDataEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import Foundation

struct ResultDataEntity {
    var correctCount: Int
    var inCorrectCount: Int
    var totalQuestions: Int
    var baseBalance: Int
}

extension ResultDataEntity {
    static func mock() -> [ResultDataEntity] {
        return [
            .init(
                correctCount: 3,
                inCorrectCount: 7,
                totalQuestions: 10,
                baseBalance: 5
            ),
            .init(
                correctCount: 5,
                inCorrectCount: 5,
                totalQuestions: 10,
                baseBalance: 5
            ),
            .init(
                correctCount: 7,
                inCorrectCount: 3,
                totalQuestions: 10,
                baseBalance: 5
            ),
            .init(
                correctCount: 10,
                inCorrectCount: 10,
                totalQuestions: 10,
                baseBalance: 5
            )
        ]
    }
}
