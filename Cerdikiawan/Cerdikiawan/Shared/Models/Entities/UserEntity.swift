//
//  UserEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

struct UserEntity {
    let id: String
    var name: String
    var email: String
    var balance: Int
    var dateOfBirth: Date
}

extension UserEntity {
    static func mock() -> [UserEntity] {
        return [
            .init(
                id: "user-id-mock-01",
                name: "NABIL RAFI SUKRI MAPPEABANG",
                email: "nabil@cerdikiawan.com",
                balance: 100,
                dateOfBirth: Date()
            )
        ]
    }
}
