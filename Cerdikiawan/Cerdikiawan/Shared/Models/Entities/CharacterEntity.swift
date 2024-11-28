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
    let imagePath: String
    let description: String
}

extension CharacterEntity {
    static func mock() -> [CharacterEntity] {
        return [
            .init(
                id: "id-04",
                name: "budi",
                imagePath: "BUDI",
                description: "Budi adalah sesosok orang yang disiplin dan bertanggung jawab! Mungkin dengan bersama Budi, kamu juga ikut menjadi disiplin dan bertanggung jawab."
            ),
            .init(
                id: "id-01",
                name: "juan",
                imagePath: "JUAN",
                description: "Budi adalah sesosok orang yang disiplin dan bertanggung jawab! Mungkin dengan bersama Budi, kamu juga ikut menjadi disiplin dan bertanggung jawab."
            ),
            .init(
                id: "07532921-149d-431a-bc2e-0251d5b06afd",
                name: "hans",
                imagePath: "HANS",
                description: "Budi adalah sesosok orang yang disiplin dan bertanggung jawab! Mungkin dengan bersama Budi, kamu juga ikut menjadi disiplin dan bertanggung jawab."
            ),
            .init(
                id: "id-03",
                name: "bryon",
                imagePath: "BRYON",
                description: "Budi adalah sesosok orang yang disiplin dan bertanggung jawab! Mungkin dengan bersama Budi, kamu juga ikut menjadi disiplin dan bertanggung jawab."
            )
        ]
    }
}
