//
//  CerdikiawanCharacterContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanCharacterContainer: View {
    @Binding var value: String
    
    var state: CerdikiawanCharacterContainerState
    var onDeleteAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(value)
                    .font(state.font)
                    .fontWeight(state.fontWeight)
                    .foregroundStyle(state.textColor)
                Spacer()
                
                if state == .normal {
                    DeleteButton()
                        .onTapGesture {
                            if state == .normal {
                                onDeleteAction()
                            }
                        }
                }
                else {
                    if let icon = state.icon {
                        icon.imageScale(.medium)
                            .foregroundStyle(state.iconColor)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
        }
        .background(state.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .disabled(self.state != .normal)
    }
}

private struct DeleteButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "delete.left").imageScale(.medium)
                .foregroundStyle(Color(.cDarkRed))
                .padding(8)
        }
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.cDarkRed), lineWidth: 0.5)
        )
    }
}

#Preview {
    @Previewable
    @State var content: String = "LOREM IPSUM"
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanCharacterContainer(
                value: $content,
                state: .correct,
                onDeleteAction: {
                    content.removeLast()
                }
            )
        }
        .padding(.horizontal, 16)
    }
    
}
