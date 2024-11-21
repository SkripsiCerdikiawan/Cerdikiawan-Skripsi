//
//  CerdikiawanCharacterDialogue.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanAvatarDialogue: View {
    var avatar: AvatarEntity
    var state: CerdikiawanAvatarState
    var message: String
    
    var body: some View {
        HStack {
            CerdikiawanAvatar(
                avatar: avatar,
                state: state
            )
            
            VStack {
                Text(message)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 75)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            .background(Color(.cWhite))
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanAvatarDialogue(
            avatar: AvatarEntity.mock()[0],
            state: .normal,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
        .padding(.horizontal, 16)
    }
}
