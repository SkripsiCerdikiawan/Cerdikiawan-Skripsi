//
//  CerdikiawanCharacterChoiceButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanCharacterChoiceButton: View {
    var label: String
    var type: CerdikiawanCharacterChoiceButtonType
    var action: () -> Void
    
    var body: some View {        
        Button(
            action: {
                if type == .normal || type == .selected {
                    action()
                }
            },
            label: {
                Text(label)
                    .foregroundStyle(type.textColor)
                    .font(type.font)
                    .fontWeight(type.fontWeight)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        )
        .buttonStyle(
            CerdikiawanCharacterChoiceButtonStyle(type: type)
        )
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
                type: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                type: .selected,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                type: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                type: .correct,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                type: .incorrect,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
            CerdikiawanCharacterChoiceButton(
                label: "T",
                type: .normal,
                action: {
                    debugPrint("Character T is Pressed")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
