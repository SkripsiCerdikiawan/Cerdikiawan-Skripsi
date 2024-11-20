//
//  CerdikiawanVoiceOverButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanVoiceOverButton: View {
    var state: CerdikiawanVoiceOverButtonType
    var onTapAction: () -> Void
    
    var body: some View {
        Button(
            action: {
                onTapAction()
            },
            label: {
                Image(systemName: "speaker.wave.2")
                    .imageScale(.medium)
                    .foregroundStyle(state.foregroundColor)
            }
        )
        .buttonStyle(CerdikiawanVoiceOverButtonStyle(type: state))
    }
}

#Preview {
    CerdikiawanVoiceOverButton(
        state: .disabled,
        onTapAction: {
            print("Voice Over Button tapped")
        }
    )
}
