//
//  CerdikiawanButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanButton: View {
    var type: CerdikiawanButtonType = .primary
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(
            action: {
                if type != .disabled {
                    action()
                }
            },
            label: {
                Text(label)
                    .padding(16)
            }
        )
        .buttonStyle(CerdikiawanButtonStyle(type: type))
        .disabled(type == .disabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        CerdikiawanButton(
            type: .primary,
            label: "Button",
            action: {
                debugPrint("Button Pressed")
            }
        )
        
        CerdikiawanButton(
            type: .secondary,
            label: "Button",
            action: {
                debugPrint("Button Pressed")
            }
        )
        
        CerdikiawanButton(
            type: .destructive,
            label: "Button",
            action: {
                debugPrint("Button Pressed")
            }
        )
        
        CerdikiawanButton(
            type: .disabled,
            label: "Button",
            action: {
                debugPrint("Button Pressed")
            }
        )
    }
    .padding(.horizontal, 16)
}
