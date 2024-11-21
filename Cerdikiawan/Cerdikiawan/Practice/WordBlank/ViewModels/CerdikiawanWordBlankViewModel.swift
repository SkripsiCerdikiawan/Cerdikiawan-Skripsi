//
//  CerdikiawanWordBlankViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanWordBlankViewModel: ObservableObject {
    let page: PageEntity
    let data: WordBlankEntity
    
    @Published var word: String
    @Published var wordArrangement: [WordBlankCharacterEntity]
    @Published var state: CerdikiawanWordBlankContainerState
    
    let avatar: AvatarEntity
    @Published var avatarDialogueState: CerdikiawanAvatarDialogueContainerState
    @Published var avatarDialogue: String
    
    @Published var isCorrect: Bool
    
    init(
        page: PageEntity,
        data: WordBlankEntity,
        avatar: AvatarEntity
    ) {
        self.page = page
        self.data = data
        
        self.word = ""
        self.wordArrangement = []
        self.state = .answering
        
        self.avatar = avatar
        self.avatarDialogueState = .normal
        self.avatarDialogue = "Sentuh dan susun kata yang sesuai!"
        self.isCorrect = false
    }
    
    // Function to handle user tap on a character
    func handleTap(char: WordBlankCharacterEntity) {
        if let index = wordArrangement.firstIndex(where: { $0.id == char.id }) {
            // If character is already selected, remove character
            wordArrangement.remove(at: index)
        }
        else {
            // else if not selected, append character
            wordArrangement.append(char)
        }
        word = wordArrangement.map({ $0.character }).joined()
        
        // Set state whenever user has inputted character or not
        if word.isEmpty {
            avatarDialogueState = .normal
        }
        else {
            avatarDialogueState = .checkAnswer
        }
    }
    
    // Function to determine Container Type
    func determineType(state: CerdikiawanWordBlankContainerState) -> CerdikiawanCharacterContainerState {
        switch state {
        case .answering:
            return .normal
        case .feedback:
            if word == data.correctAnswerWord {
                return .correct
            }
            else {
                return .incorrect
            }
        }
    }
    
    // Function to determine button type
    func determineType(char: WordBlankCharacterEntity) -> CerdikiawanCharacterChoiceButtonType {
        switch state {
        case .answering:
            if wordArrangement.contains(where: { $0.id == char.id }) {
                return .selected
            }
        case .feedback:
            let character = Character(char.character)
            if data.correctAnswerWord.contains(character) {
                return .correct
            } else if wordArrangement.contains(where: { $0.id == char.id }) {
                return .incorrect
            } else {
                return .normal
            }
        }
        
        return .normal
    }
    
    // Function to check answer
    func validateAnswer() {
        // Set state to feedback
        self.state = .feedback
        
        // Validate answer
        self.isCorrect = self.word == data.correctAnswerWord
        
        if isCorrect {
            self.avatarDialogueState = .correct
            self.avatarDialogue = data.feedback.correctFeedback
        }
        else {
            self.avatarDialogueState = .incorrect
            self.avatarDialogue = data.feedback.incorrectFeedback
        }
    }
}
