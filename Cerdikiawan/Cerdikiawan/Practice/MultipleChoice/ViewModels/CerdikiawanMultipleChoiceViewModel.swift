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
    
    var avatar: AvatarEntity
    @Published var avatarDialogueState: CerdikiawanAvatarDialogueContainerState
    @Published var avatarDialogue: String
    
    @Published var result: Bool
    
    init(
        page: PageEntity,
        data: MultipleChoiceEntity,
        avatar: AvatarEntity
    ){
        self.page = page
        self.data = data
        self.multipleChoiceState = .answering
        self.selectedAnswerID = ""
        
        self.avatar = avatar
        self.avatarDialogueState = .normal
        self.avatarDialogue = "Pilihlah satu jawaban yang menurut kamu sesuai"
        self.result = false
    }
    
    // Function that will be called when the multiple choice is selected
    func handleChoiceSelection(answer: MultipleChoiceAnswerEntity) {
        self.selectedAnswerID = answer.id
        self.avatarDialogueState = .checkAnswer
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
        let isCorrect = selectedAnswerID == data.correctAnswerID
        if isCorrect {
            self.avatarDialogueState = .correct
            self.avatarDialogue = data.correctFeedback
            self.result = true
        }
        else {
            self.avatarDialogueState = .incorrect
            self.avatarDialogue = data.incorrectFeedback
            self.result = false
        }
    }
}
