//
//  ParagraphEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

struct ParagraphEntity {
    var id: String
    var paragraphText: String
    var paragraphSoundPath: String
}

extension ParagraphEntity {
    static func mock() -> [ParagraphEntity] {
        return [
            .init(
                id: "paragraph-id-01",
                paragraphText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                paragraphSoundPath: "TEMP"
            ),
            .init(
                id: "paragraph-id-02",
                paragraphText: "Praesent elementum ac sapien id sollicitudin. Donec a finibus ex, a condimentum erat. Phasellus egestas aliquam suscipit. Sed dapibus porttitor enim. Mauris eget viverra tortor, ac venenatis nulla. Donec lacus enim, pharetra id erat vel, auctor aliquam dolor.",
                paragraphSoundPath: "TEMP"
            )
        ]
    }
}
