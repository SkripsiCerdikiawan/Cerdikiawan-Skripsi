//
//  CerdikiawanCharacterDialogue.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanCharacterDialogue: View {
    var character: CharacterEntity
    var state: CerdikiawanCharacterState
    var message: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            CerdikiawanCharacter(
                character: character,
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
        CerdikiawanCharacterDialogue(
            character: CharacterEntity.mock()[0],
            state: .normal,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
        .padding(.horizontal, 16)
    }
}
