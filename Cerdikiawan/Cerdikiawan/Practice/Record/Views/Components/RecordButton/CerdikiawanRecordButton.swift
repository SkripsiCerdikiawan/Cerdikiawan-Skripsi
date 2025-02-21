//
//  CerdikiawanRecordButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanRecordButton: View {
    var type: CerdikiawanRecordButtonType
    var onTapAction: () -> Void
    
    var body: some View {
        VStack {
            Button(
                action: {
                    onTapAction()
                },
                label: {
                    VStack {
                        VStack {
                            Image(systemName: type.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundStyle(type.foregroundStyle)
                                .frame(width: 40, height: 40)
                        }
                        .frame(width: 125, height: 125)
                    }
                }
            )
            .buttonStyle(CerdikiawanRecordButtonStyle(type: type))
            
            Text(type.text)
                .multilineTextAlignment(.center)
                .foregroundStyle(type.fontColor)
        }
        .frame(maxWidth: 125)
        
    }
}


#Preview {
    HStack(spacing: 24) {
        CerdikiawanRecordButton(
            type: .replay,
            onTapAction: {
                print("Tapped!")
            }
        )
        
        CerdikiawanRecordButton(
            type: .rerecord,
            onTapAction: {
                print("Tapped!")
            }
        )
    }
}
