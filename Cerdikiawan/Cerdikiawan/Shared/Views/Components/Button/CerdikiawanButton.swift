//
//  CerdikiawanButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanButton: View {
    var style: CerdikiawanButtonStyle = .primary
    var label: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text(label)
                .foregroundStyle(style.labelColor)
                .padding(16)
        }
        .frame(maxWidth: .infinity)
        .background(style.fillColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .onTapGesture {
            if self.style != .disabled {
                action()
            }
        }
    }
}

#Preview {
    CerdikiawanButton(
        style: .disabled,
        label: "Button",
        action: {
            debugPrint("Button Pressed")
        }
    )
    .padding(.horizontal, 16)
}
