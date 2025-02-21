//
//  CerdikiawanWordMatchTextContainerStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanWordMatchTextContainerStyle: ButtonStyle {
    var type: CerdikiawanWordMatchTextContainerType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type.borderColor, lineWidth: type.borderWidth)
            )
            .background(type.backgroundColor(isPressed: configuration.isPressed))
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .foregroundStyle(type.textColor(isPressed: configuration.isPressed))
            .frame(width: 172, height: 72)
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
    }
}
