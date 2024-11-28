//
//  WordMatchEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 18/11/24.
//

struct WordMatchEntity: QuestionProtocol {
    var id: String
    var prompt: String
    var questions: [WordMatchTextEntity] // List of question
    var answers: [WordMatchTextEntity] // List of all possible answer
    
    var pair: [String : String] // Answer: Question Entity ID with Answer Entity ID
    var type: QuestionType
    var feedback: FeedbackEntity
}

extension WordMatchEntity {
    static func mock() -> [WordMatchEntity] {
        return [
            .init(
                id: "wm-01",
                prompt: "Sesuaikan sinonim yang sesuai dibawah ini",
                questions: [
                    .init(
                        id: "wm-ques-01",
                        content: "Kehilangan Cairan Tubuh"
                    ),
                    .init(
                        id: "wm-ques-02",
                        content: "Angkuh"
                    ),
                    .init(
                        id: "wm-ques-03",
                        content: "Pakar"
                    )
                ],
                answers: [
                    .init(
                        id: "wm-ans-01",
                        content: "Dehidrasi"
                    ),
                    .init(
                        id: "wm-ans-02",
                        content: "Ahli"
                    ),
                    .init(
                        id: "wm-ans-03",
                        content: "Sombong"
                    ),
                    .init(
                        id: "wm-ans-04",
                        content: "Jahat"
                    ),
                    
                ],
                pair: [
                    "wm-ques-01" : "wm-ans-01",
                    "wm-ques-02" : "wm-ans-03",
                    "wm-ques-03" : "wm-ans-02"
                ],
                type: .kosakata,
                feedback: .mock()[0]
            )
        ]
    }
}
