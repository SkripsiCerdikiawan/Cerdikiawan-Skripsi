//
//  CerdikiawanMultipleChoiceButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceButton: View {
    var label: String
    var state: CerdikiawanMultipleChoiceButtonState
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            if let image = state.icon {
                image.imageScale(.medium).foregroundStyle(state.textColor)
                    .padding(.leading, 16)
            }
            
            Text(label)
                .foregroundStyle(state.textColor)
                .font(state.font)
                .fontWeight(state.fontWeight)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
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
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        
        VStack(spacing: 16) {
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                state: .normal,
                action: {
                    debugPrint("Choice 1 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                state: .selected,
                action: {
                    debugPrint("Choice 2 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                state: .correct,
                action: {
                    debugPrint("Choice 3 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                state: .incorrect,
                action: {
                    debugPrint("Choice 4 selected")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
