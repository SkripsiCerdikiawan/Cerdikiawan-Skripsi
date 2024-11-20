//
//  CerdikiawanMultipleChoiceContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceContainer: View {
    @ObservedObject var viewModel: CerdikiawanMultipleChoiceViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(viewModel.data.question)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 8) {
                ForEach(viewModel.data.answer, id: \.id) { answer in
                    CerdikiawanMultipleChoiceButton(
                        label: answer.content,
                        type: viewModel.determineType(answer: answer.id),
                        action: {
                            viewModel.handleChoiceSelection(answer: answer)
                        }
                    )
                    .disabled(viewModel.state == .feedback)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    @Previewable
    @StateObject var viewModel = CerdikiawanMultipleChoiceViewModel(
        data: .mock()[0]
    )
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanMultipleChoiceContainer(
                viewModel: viewModel
            )
            CerdikiawanButton(
                label: "Change State",
                action: {
                    viewModel.state = .feedback
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
