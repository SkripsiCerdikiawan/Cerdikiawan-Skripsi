//
//  CerdikiawanReadingsText.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanParagraph: View {
    var content: String
    
    var state: CerdikiawanVoiceOverButtonType
    var onVoiceButtonTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            CerdikiawanVoiceOverButton(
                state: state,
                onTapAction: {
                    onVoiceButtonTapped()
                }
            )
            
            Text(content)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable
    @State var isPlaying: Bool = false
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanParagraph(
            content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget erat justo.",
            state: isPlaying ? .disabled : .enabled,
            onVoiceButtonTapped: {
                isPlaying.toggle()
            }
        )
        .padding(.horizontal, 16)
    }
}
