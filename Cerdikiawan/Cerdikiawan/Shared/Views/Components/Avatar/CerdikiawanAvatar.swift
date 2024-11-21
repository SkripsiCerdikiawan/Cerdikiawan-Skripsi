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
                .resizable()
                .frame(width: 100, height: 125)
                .scaledToFill()
        }
    }
}

#Preview {
    CerdikiawanAvatar(
        avatar: AvatarEntity.mock()[0],
        state: .sad
    )
}
