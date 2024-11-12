//
//  CerdikiawanBorderlessButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanBorderlessButton: View {
    var state: CerdikiawanBorderlessButtonState = .enabled
    
    var text: String
    var onTapAction: () -> Void
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundStyle(state.textColor)
                .fontWeight(.medium)
        }
        .onTapGesture {
            if state == .enabled {
                onTapAction()
            }
        }
    }
}

#Preview {
    CerdikiawanBorderlessButton(
        state: .disabled,
        text: "Hello World",
        onTapAction: {
            print("Borderless Button tapped!")
        }
    )
}
