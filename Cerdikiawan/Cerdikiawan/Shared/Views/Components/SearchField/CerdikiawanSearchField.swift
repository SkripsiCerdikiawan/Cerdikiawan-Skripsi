//
//  CerdikiawanSearchField.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

struct CerdikiawanSearchField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundStyle(Color(.secondaryLabel))
                TextField(placeholder, text: $text)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.tertiarySystemFill))
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }
}

#Preview {
    @Previewable
    @State var textField: String = ""
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        
        VStack {
            CerdikiawanSearchField(
                placeholder: "This is a placeholder",
                text: $textField
            )
        }
        .padding(.horizontal, 16)
    }
}
