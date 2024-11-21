//
//  Avatar.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct AvatarEntity {
    let id: String
    let name: String
}

extension AvatarEntity {
    static func mock() -> [AvatarEntity] {
        return [
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
            ),
            .init(
                id: "id-04",
                name: "budi"
            ),
        ]
    }
}
