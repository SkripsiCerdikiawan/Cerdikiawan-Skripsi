//
//  CerdikiawanVoiceOverButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanVoiceOverButton: View {
    var state: CerdikiawanVoiceOverButtonState
    var onTapAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "speaker.wave.2")
                .imageScale(.medium)
                .foregroundStyle(state.foregroundColor)
        }
        .frame(width: 40, height: 40)
        .background(state.backgroundColor)
        .onTapGesture {
            if state == .enabled {
                onTapAction()
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    CerdikiawanVoiceOverButton(
        state: .enabled,
        onTapAction: {
            print("Voice Over Button tapped")
        }
    )
}
