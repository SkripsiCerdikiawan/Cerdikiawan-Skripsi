//
//  CerdikiawanTextField.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var state: CerdikiawanTextFieldState = .enabled
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
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
            CerdikiawanTextField(
                placeholder: "This is a placeholder",
                text: $textField,
                state: .disabled
            )
        }
        .padding(.horizontal, 16)
    }
    
}
