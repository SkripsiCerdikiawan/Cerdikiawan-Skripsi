//
//  ReportLevelEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

struct ReportLevelEntity {
    var id: String
    var level: Int
    var levelDescription: String
    var stories: [ReportStoryEntity]
}

extension ReportLevelEntity {
    static func mock() -> [ReportLevelEntity] {
        return [
            .init(
                id: "level-1-id",
                level: 1,
                levelDescription: "Awal untuk meningkatkan pemahaman membaca",
                stories: []
            ),
            .init(
                id: "level-2-id",
                level: 2,
                levelDescription: "Sedikit tantangan untuk menguji kemampuan membacamu!",
                stories: []
            ),
            .init(
                id: "level-3-id",
                level: 3,
                levelDescription: "Buktikan disini kalau kamu mempunyai pemahaman membaca yang baik!",
                stories: []
            )
        ].sorted(by: { $0.level < $1.level })
    }
}
