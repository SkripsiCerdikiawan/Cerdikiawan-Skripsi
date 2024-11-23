//
//  PracticeEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

struct PracticeEntity {
    var page: PageEntity
    var question: any QuestionProtocol
}

extension PracticeEntity {
    static func mock() -> [PracticeEntity] {
        return [
            .init(
                page: .mock()[0],
                question: MultipleChoiceEntity.mock()[0]
            ),
            .init(
                page: .mock()[0],
                question: WordBlankEntity.mock()[0]
            ),
            .init(
                page: .mock()[0],
                question: WordMatchEntity.mock()[0]
            )
        ]
    }
}
