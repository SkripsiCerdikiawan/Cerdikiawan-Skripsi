//
//  CerdikiawanCharacter.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanCharacter: View {
    var character: CharacterEntity
    var state: CerdikiawanCharacterState = .normal
    
    var body: some View {
        VStack {
            state.displayImage(character: character)
                .resizable()
                .frame(width: 100, height: 125)
                .scaledToFill()
        }
    }
}

#Preview {
    CerdikiawanCharacter(
        character: CharacterEntity.mock()[0],
        state: .sad
    )
}
