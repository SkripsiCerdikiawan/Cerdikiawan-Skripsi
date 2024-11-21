//
//  FeedbackEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

struct FeedbackEntity {
    var correctFeedback: String
    var incorrectFeedback: String
}

extension FeedbackEntity {
    static func mock() -> [FeedbackEntity] {
        return [
            .init(
                correctFeedback: "Hore! Jawaban kamu benar!",
                incorrectFeedback: "Hmm.. Jawaban kamu kelihatannya salah..."
            )
        ]
    }
}
