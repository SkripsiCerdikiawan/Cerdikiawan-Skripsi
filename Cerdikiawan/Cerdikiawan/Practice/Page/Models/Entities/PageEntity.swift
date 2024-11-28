//
//  PassageEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

struct PageEntity {
    var storyImage: String
    var paragraph: [ParagraphEntity]
}

extension PageEntity {
    static func mock() -> [PageEntity] {
        return [
            .init(
                storyImage: "DEBUG_IMAGE",
                paragraph: [
                    .mock()[0],
                    .mock()[1]
                ]
            )
        ]
    }
}
