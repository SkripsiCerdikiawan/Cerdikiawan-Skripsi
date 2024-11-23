//
//  CerdikiawanSecureField.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import SwiftUI

struct CerdikiawanSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var state: CerdikiawanTextFieldState = .enabled
    
    var body: some View {
        VStack {
            SecureField(placeholder, text: $text)
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .background(state.backgroundColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .foregroundStyle(state.textColor)
                .disabled(state == .disabled)
        }
    }
}

#Preview {
    @Previewable
    @State var textField: String = ""
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        
        VStack {
            CerdikiawanSecureField(
                placeholder: "This is a placeholder",
                text: $textField,
                state: .disabled
            )
        }
        .padding(.horizontal, 16)
    }
    
}
