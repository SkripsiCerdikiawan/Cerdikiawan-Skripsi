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
                HStack(alignment: .center, spacing: 16) {
                    if let image = type.icon {
                        Image(systemName: image)
                            .imageScale(.medium)
                            .foregroundStyle(type.textColor)
                    }
                    
                    Text(label)
                        .foregroundStyle(type.textColor)
                        .font(type.font)
                        .fontWeight(type.fontWeight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 24)
                }
                .padding(.horizontal, 16)
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
                label: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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
                label: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                type: .correct,
                action: {
                    debugPrint("Choice 3 selected")
                }
            )
            CerdikiawanMultipleChoiceButton(
                label: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sagittis arcu ac ullamcorper iaculis. Aenean sagittis sem quam, non eleifend velit iaculis a.",
                type: .incorrect,
                action: {
                    debugPrint("Choice 4 selected")
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
