//
//  CerdikiawanLetterChoiceButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanLetterChoiceButton: View {
    var label: String
    var type: CerdikiawanLetterChoiceButtonType
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
            CerdikiawanLetterChoiceButtonStyle(type: type)
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
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .normal,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .selected,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .normal,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .correct,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .incorrect,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
            CerdikiawanLetterChoiceButton(
                label: "T",
                type: .normal,
                action: {
                    debugPrint("Letter T is Pressed")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
