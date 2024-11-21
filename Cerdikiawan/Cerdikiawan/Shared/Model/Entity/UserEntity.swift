//
//  UserEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

struct UserEntity {
    let id: String
    var name: String
    var balance: Int
}

extension UserEntity {
    static func mock() -> [UserEntity] {
        return [
            .init(
                id: "user-id-mock-01",
                name: "NABIL RAFI SUKRI MAPPEABANG",
                balance: 100
            )
        ]
    }
}
