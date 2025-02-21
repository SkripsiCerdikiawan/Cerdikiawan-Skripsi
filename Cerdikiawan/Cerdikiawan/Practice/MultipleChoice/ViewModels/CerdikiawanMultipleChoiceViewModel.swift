//
//  CerdikiawanMultipleChoiceViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanMultipleChoiceViewModel: ObservableObject {
    var page: PageEntity
    var data: MultipleChoiceEntity
    @Published var multipleChoiceState: CerdikiawanMultipleChoiceContainerState
    @Published var selectedAnswerID: String
    
    var character: CharacterEntity
    @Published var characterDialogueState: CerdikiawanCharacterDialogueContainerState
    @Published var characterDialogue: String
    
    @Published var isCorrect: Bool
    
    init(
        page: PageEntity,
        data: MultipleChoiceEntity,
        character: CharacterEntity
    ){
        self.page = page
        self.data = data
        self.multipleChoiceState = .answering
        self.selectedAnswerID = ""
        
        self.character = character
        self.characterDialogueState = .normal
        self.characterDialogue = "Pilihlah satu jawaban yang menurut kamu sesuai"
        self.isCorrect = false
    }
    
    // Function that will be called when the multiple choice is selected
    func handleChoiceSelection(answer: MultipleChoiceAnswerEntity) {
        self.selectedAnswerID = answer.id
        self.characterDialogueState = .checkAnswer
    }
    
    // Function determine choices state
    func determineType(answer: String) -> CerdikiawanMultipleChoiceButtonType {
        switch multipleChoiceState {
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
    
    // Function to check answer
    func validateAnswer() {
        // Set state to feedback
        self.multipleChoiceState = .feedback
        
        // Validate answer
        self.isCorrect = selectedAnswerID == data.correctAnswerID
        
        if isCorrect {
            self.characterDialogueState = .correct
            self.characterDialogue = data.feedback.correctFeedback
            self.isCorrect = true
        }
        else {
            self.characterDialogueState = .incorrect
            self.characterDialogue = data.feedback.incorrectFeedback
            self.isCorrect = false
        }
    }
}
