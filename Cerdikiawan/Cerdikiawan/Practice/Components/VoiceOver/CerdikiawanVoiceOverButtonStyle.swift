//
//  CerdikiawanVoiceOverButtonStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanVoiceOverButtonStyle: ButtonStyle {
    var type: CerdikiawanVoiceOverButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 40, height: 40)
            .background(type.backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .foregroundStyle(type.foregroundColor)
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
