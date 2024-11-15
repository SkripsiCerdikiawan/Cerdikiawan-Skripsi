//
//  CerdikiawanMultipleChoiceButtonStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceButtonStyle: ButtonStyle {
    var type: CerdikiawanMultipleChoiceButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type.borderColor, lineWidth: type.borderWidth)
            )
            .background(type.backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .frame(maxWidth: .infinity)
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
