//
//  CerdikiawanDatePickerField.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import SwiftUI

struct CerdikiawanDatePickerField: View {
    var placeholder: String
    @Binding var date: Date
    
    var state: CerdikiawanTextFieldState = .enabled
    
    var body: some View {
        VStack {
            DatePicker(placeholder, selection: $date, displayedComponents: .date)
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
    @State var date: Date = Date()
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        
        VStack {
            CerdikiawanDatePickerField(
                placeholder: "This is a placeholder",
                date: $date,
                state: .enabled
            )
        }
        .padding(.horizontal, 16)
    }
    
}
