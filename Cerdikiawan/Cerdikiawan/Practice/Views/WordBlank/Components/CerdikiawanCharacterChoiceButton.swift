//
//  CerdikiawanCharacterChoiceButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanCharacterChoiceButton: View {
    var label: String
    var state: CerdikiawanCharacterChoiceButtonState
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text(label)
                .foregroundStyle(state.textColor)
                .font(state.font)
                .fontWeight(state.fontWeight)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(state.borderColor, lineWidth: state.borderWidth)
        )
        .background(state.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .onTapGesture {
            action()
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]

    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        LazyVGrid(columns: columns) {
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                state: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
