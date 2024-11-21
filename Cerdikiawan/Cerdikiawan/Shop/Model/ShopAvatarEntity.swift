//
//  ShopAvatarEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct ShopAvatarEntity {
    let avatar: AvatarEntity
    let price: Int
}

extension ShopAvatarEntity {
    static func mock() -> [ShopAvatarEntity] {
        return [
            .init(
                avatar: AvatarEntity.mock()[0],
                price: 100
            ),
            .init(
                avatar: AvatarEntity.mock()[1],
                price: 200
            ),
            .init(
                avatar: AvatarEntity.mock()[2],
                price: 10
            ),
            .init(
                avatar: AvatarEntity.mock()[3],
                price: 400
            )
        ]
    }
}
