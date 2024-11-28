//
//  PracticeEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

struct PracticeEntity: Identifiable {
    var id: String
    var page: PageEntity
    var question: any QuestionProtocol
}

extension PracticeEntity {
    static func mock() -> [PracticeEntity] {
        return [
            .init(
                id: "practice-mock-01",
                page: .mock()[0],
                question: MultipleChoiceEntity.mock()[0]
            ),
            .init(
                id: "practice-mock-02",
                page: .mock()[0],
                question: WordBlankEntity.mock()[0]
            ),
            .init(
                id: "practice-mock-03",
                page: .mock()[0],
                question: WordMatchEntity.mock()[0]
            ),
            .init(
                id: "practice-mock-04",
                page: .mock()[0],
                question: MultipleChoiceEntity.mock()[0]
            ),
        ]
    }
}
