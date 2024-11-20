//
//  CerdikiawanMultipleChoiceViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanMultipleChoiceViewModel: ObservableObject {
    var data: MultipleChoiceEntity
    @Published var state: CerdikiawanMultipleChoiceContainerState
    @Published var selectedAnswerID: String
    
    init(data: MultipleChoiceEntity){
        self.data = data
        self.state = .answering
        self.selectedAnswerID = ""
    }
    
    func handleChoiceSelection(answer: MultipleChoiceAnswerEntity) {
        self.selectedAnswerID = answer.id
    }
    
    // Function determine choices state
    func determineType(answer: String) -> CerdikiawanMultipleChoiceButtonType {
        switch state {
        case .answering:
            // State to selected if answer is the same with selectedAnswerID
            if answer == selectedAnswerID {
                return .selected
            }
        case .feedback:
            // if at feedback and answer is the correct answer, return correct
            if answer == data.correctAnswerID {
                return .correct
            }
            // if at feedback and the selected answer is not correct, return incorrect
            else if selectedAnswerID == answer {
                return .incorrect
            }
        }
        return .normal
    }
}
