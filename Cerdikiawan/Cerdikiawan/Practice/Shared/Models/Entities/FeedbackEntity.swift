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
            ),
            .init(
                correctFeedback: "Jawaban ini sesuai dengan pesan Ibu Kelinci yang meminta untuk menjaga jarak, kebersihan, dan tidak bersentuhan untuk mencegah penularan penyakit. \n\n Hal ini menunjukkan bahwa larangan tersebut adalah bentuk perlindungan, bukan semata-mata untuk melarang atau membatasi.",
                incorrectFeedback: "Jawaban ini sesuai dengan pesan Ibu Kelinci yang meminta untuk menjaga jarak, kebersihan, dan tidak bersentuhan untuk mencegah penularan penyakit. \n\n Hal ini menunjukkan bahwa larangan tersebut adalah bentuk perlindungan, bukan semata-mata untuk melarang atau membatasi."
            )
        ]
    }
}
