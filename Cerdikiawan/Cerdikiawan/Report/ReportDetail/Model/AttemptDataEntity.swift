//
//  AttemptDataEntity.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

struct AttemptDataEntity {
    let attemptId: String
    let storyId: String
    let date: Date
    let kosakataPercentage: Int
    let idePokokPercentage: Int
    let implisitPercentage: Int
    let soundPath: String
}

extension AttemptDataEntity {
    static func mock() -> [AttemptDataEntity] {
        return [
            .init(attemptId: "Attempt1",
                storyId: "Story1",
                date: Date(),
                  kosakataPercentage: 20,
                  idePokokPercentage: 20,
                  implisitPercentage: 30,
                  soundPath: "Sound1"
                 ),
            .init(attemptId: "Attempt2",
                storyId: "Story1",
                date: Date(),
                  kosakataPercentage: 20,
                  idePokokPercentage: 20,
                  implisitPercentage: 30,
                  soundPath: "Sound2"
                 ),
            .init(attemptId: "Attempt3",
                storyId: "Story2",
                date: Date(),
                  kosakataPercentage: 20,
                  idePokokPercentage: 20,
                  implisitPercentage: 30,
                  soundPath: "Sound3"
                 )
        ].sorted(by: { $0.date < $1.date })
    }
}
