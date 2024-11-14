//
//  CerdikiawanRecordButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanRecordButton: View {
    var state: CerdikiawanRecordButtonStyle
    var onTapAction: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Image(systemName: state.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(state.foregroundStyle)
                        .frame(width: 40, height: 40)
                }
                .frame(width: 125, height: 125)
            }
            .background(state.backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: state.borderRadius)
            )
            
            Text(state.text)
                .multilineTextAlignment(.center)
                .foregroundStyle(state.fontColor)
        }
        .frame(maxWidth: 125)
        
    }
}


#Preview {
    CerdikiawanRecordButton(
        state: .normal,
        onTapAction: {
            print("Tapped!")
        }
    )
}
