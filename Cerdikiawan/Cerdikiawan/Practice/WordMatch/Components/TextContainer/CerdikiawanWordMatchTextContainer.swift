//
//  CerdikiawanWordMatchTextContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanWordMatchTextContainer: View {
    var label: String
    var state: CerdikiawanWordMatchTextContainerState
    var onTap: (() -> Void)?
    
    var body: some View {
        VStack {
            Text(label)
                .font(state.font)
                .fontWeight(state.fontWeight)
                .foregroundStyle(state.textColor)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(state.borderColor, lineWidth: state.borderWidth)
        )
        .background(state.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .frame(width: 172, height: 88)
        .onTapGesture {
            if state == .filled {
                onTap?()
            }
        }
        .disabled(state == .disabled)

    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Kehilangan Cairan Tubuh",
                    state: .question
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .blank
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .question
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .filled
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .question
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .correct
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .question
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    state: .incorrect
                )
            }
            CerdikiawanWordMatchTextContainer(
                label: "Text",
                state: .disabled
            )
        }
        .padding(16)
    }

}
