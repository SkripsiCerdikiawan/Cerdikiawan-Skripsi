//
//  ShopCharacterEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct ShopCharacterEntity {
    let character: CharacterEntity
    let price: Int
}

extension ShopCharacterEntity {
    static func mock() -> [ShopCharacterEntity] {
        return [
            .init(
                character: CharacterEntity.mock()[0],
                price: 100
            ),
            .init(
                character: CharacterEntity.mock()[1],
                price: 200
            ),
            .init(
                character: CharacterEntity.mock()[2],
                price: 10
            ),
            .init(
                character: CharacterEntity.mock()[3],
                price: 400
            )
        ]
    }
}
