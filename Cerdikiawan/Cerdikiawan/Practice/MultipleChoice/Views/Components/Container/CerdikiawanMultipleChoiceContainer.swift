//
//  CerdikiawanMultipleChoiceContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceContainer: View {
    var data: MultipleChoiceEntity
    @Binding var state: CerdikiawanMultipleChoiceContainerState
    @Binding var selectedAnswerID: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(data.question)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 8) {
                ForEach(data.answer, id: \.id) { answer in
                    CerdikiawanMultipleChoiceButton(
                        label: answer.content,
                        type: determineType(answer: answer.id),
                        action: {
                            self.selectedAnswerID = answer.id
                        }
                    )
                    .disabled(state == .feedback)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func determineType(answer: String) -> CerdikiawanMultipleChoiceButtonType {
        switch state {
        case .answering:
            // State to selected if answer is the same with selectedAnswerID
            if answer == self.selectedAnswerID {
                return .selected
            }
        case .feedback:
            // if at feedback and answer is the correct answer, return correct
            if answer == data.correctAnswerID {
                return .correct
            }
            // if at feedback and the selected answer is not correct, return incorrect
            else if self.selectedAnswerID == answer {
                return .incorrect
            }
        }
        return .normal
    }
}

#Preview {
    @Previewable
    @State var multipleChoiceState: CerdikiawanMultipleChoiceContainerState = .answering
    
    @Previewable
    @State var selectedAnswerID: String = ""
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanMultipleChoiceContainer(
                data: MultipleChoiceEntity.mock()[0],
                state: $multipleChoiceState,
                selectedAnswerID: $selectedAnswerID
            )
            CerdikiawanButton(
                label: "Change State",
                action: {
                    multipleChoiceState = .feedback
                }
            )
        }
        .padding(.horizontal, 16)
    }
}
