//
//  CerdikiawanRecordButtonStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

import SwiftUI

struct CerdikiawanRecordButtonStyle: ButtonStyle {
    var type: CerdikiawanRecordButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(type.backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: type.borderRadius)
            )
            .scaleEffect(configuration.isPressed ? type.scaleEffect : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
            .foregroundStyle(type.foregroundStyle)
    }
}
