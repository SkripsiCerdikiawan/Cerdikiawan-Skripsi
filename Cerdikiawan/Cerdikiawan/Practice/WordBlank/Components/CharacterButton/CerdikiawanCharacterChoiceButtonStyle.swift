//
//  CerdekiawanCharacterChoiceButtonType.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanCharacterChoiceButtonStyle: ButtonStyle {
    var type: CerdikiawanCharacterChoiceButtonType
    
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
            .frame(width: 80, height: 80)
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
