//
//  CerdikiawanMultipleChoiceButton.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceButton: View {
    var label: String
    var type: CerdikiawanMultipleChoiceButtonType
    var action: () -> Void
    
    var body: some View {
        Button(
            action: {
                if type == .normal || type == .selected {
                    action()
                }
            },
            label: {
                ZStack(alignment: .leading) {
                    if let image = type.icon {
                        Image(systemName: image)
                            .imageScale(.medium)
                            .foregroundStyle(type.textColor)
                            .padding(.leading, 16)
                    }
                    
                    Text(label)
                        .foregroundStyle(type.textColor)
                        .font(type.font)
                        .fontWeight(type.fontWeight)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                }
            }
        )
        .buttonStyle(
            CerdikiawanMultipleChoiceButtonStyle(type: type)
        )
    }
}


#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        
        VStack(spacing: 16) {
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                type: .normal,
                action: {
                    debugPrint("Choice 1 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                type: .selected,
                action: {
                    debugPrint("Choice 2 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                type: .correct,
                action: {
                    debugPrint("Choice 3 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Choice",
                type: .incorrect,
                action: {
                    debugPrint("Choice 4 selected")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
