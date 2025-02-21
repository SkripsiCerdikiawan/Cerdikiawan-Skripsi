//
//  CerdikiawanButtonStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanButtonStyle: ButtonStyle {
    var type: CerdikiawanButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .background(type.fillColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
            .foregroundStyle(type.labelColor)
    }
}
