//
//  ShopAvatarEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct ShopAvatarEntity {
    let id: UUID
    let avatar: AvatarEntity
    let price: Int
}

extension ShopAvatarEntity {
    static func mock() -> [ShopAvatarEntity] {
        return [
            .init(
                id: UUID(),
                avatar: AvatarEntity.mock(),
                price: 100
            )
        ]
    }
}
