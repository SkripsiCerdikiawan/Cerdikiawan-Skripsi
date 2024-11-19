//
//  CerdikiawanWordMatchTextContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanWordMatchTextContainer: View {
    var label: String
    var type: CerdikiawanWordMatchTextContainerType
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(
            action: {
                if type == .filled {
                    onTap?()
                }
            },
            label: {
                Text(label)
                    .font(type.font)
                    .fontWeight(type.fontWeight)
                    .foregroundStyle(type.textColor)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
            }
        )
        .buttonStyle(
            CerdikiawanWordMatchTextContainerStyle(type: type)
        )
        
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Kehilangan Cairan Tubuh",
                    type: .question,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .blank,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .question,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .filled,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .question,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .correct,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
            }
            HStack(spacing: 16) {
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .question,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
                CerdikiawanWordMatchTextContainer(
                    label: "Text",
                    type: .incorrect,
                    onTap: {
                        debugPrint("Button Pressed")
                    }
                )
            }
            CerdikiawanWordMatchTextContainer(
                label: "Text",
                type: .disabled,
                onTap: {
                    debugPrint("Button Pressed")
                }
            )
        }
        .padding(16)
    }
    
}
