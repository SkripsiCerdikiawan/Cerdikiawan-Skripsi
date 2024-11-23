//
//  CharacterEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CharacterEntity {
    let id: String
    let name: String
}

extension CharacterEntity {
    static func mock() -> [CharacterEntity] {
        return [
            .init(
                id: "id-04",
                name: "budi"
            ),
            .init(
                id: "id-01",
                name: "juan"
            ),
            .init(
                id: "id-02",
                name: "hans"
            ),
            .init(
                id: "id-03",
                name: "bryon"
            )
        ]
    }
}
