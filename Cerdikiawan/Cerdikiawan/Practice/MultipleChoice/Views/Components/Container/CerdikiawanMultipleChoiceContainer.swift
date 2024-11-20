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
                        type: determineType(answer: answer.id),
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
    
    private func determineType(answer: String) -> CerdikiawanMultipleChoiceButtonType {
        switch viewModel.state {
        case .answering:
            // State to selected if answer is the same with selectedAnswerID
            if answer == viewModel.selectedAnswerID {
                return .selected
            }
        case .feedback:
            // if at feedback and answer is the correct answer, return correct
            if answer == viewModel.data.correctAnswerID {
                return .correct
            }
            // if at feedback and the selected answer is not correct, return incorrect
            else if viewModel.selectedAnswerID == answer {
                return .incorrect
            }
        }
        return .normal
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
