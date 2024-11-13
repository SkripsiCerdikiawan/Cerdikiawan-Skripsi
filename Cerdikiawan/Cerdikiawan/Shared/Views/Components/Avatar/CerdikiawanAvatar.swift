//
//  CerdikiawanAvatar.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanAvatar: View {
    var avatar: AvatarEntity
    var state: CerdikiawanAvatarState = .normal
    
    var body: some View {
        VStack {
            state.displayImage(avatar: avatar)
        }
    }
}

#Preview {
    CerdikiawanAvatar(
        avatar: .init(
            id: "id-01",
            name: "juan"
        ),
        state: .sad
    )
}
