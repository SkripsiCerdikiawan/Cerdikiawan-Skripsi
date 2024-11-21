//
//  LevelEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct LevelEntity {
    var id: String
    var level: Int
    var levelDescription: String
    var stories: [StoryEntity]
}

extension LevelEntity {
    static func mock() -> [Self] {
        return [
            .init(
                id: "level-1-id",
                level: 1,
                levelDescription: "Awal untuk meningkatkan pemahaman membaca",
                stories: StoryEntity.mock()
            ),
            .init(
                id: "level-2-id",
                level: 2,
                levelDescription: "Sedikit tantangan untuk menguji kemampuan membacamu!",
                stories: StoryEntity.mock()
            ),
            .init(
                id: "level-3-id",
                level: 3,
                levelDescription: "Buktikan disini kalau kamu mempunyai pemahaman membaca yang baik!",
                stories: StoryEntity.mock()
            )
        ].sorted(by: { $0.level < $1.level })
    }
}
