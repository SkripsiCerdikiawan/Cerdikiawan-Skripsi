//
//  LevelEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct LevelEntity {
    var level: Int
    var levelDescription: String
    var stories: [StoryEntity]
}

extension LevelEntity {
    static func mock() -> [Self] {
        return [
            .init(
                level: 1,
                levelDescription: "Awal untuk meningkatkan pemahaman membaca",
                stories: StoryEntity.mock()
            ),
            .init(
                level: 2,
                levelDescription: "Sedikit tantangan untuk menguji kemampuan membacamu!",
                stories: StoryEntity.mock()
            ),
            .init(
                level: 3,
                levelDescription: "Buktikan disini kalau kamu mempunyai pemahaman membaca yang baik!",
                stories: StoryEntity.mock()
            )
        ].sorted(by: { $0.level < $1.level })
    }
}
