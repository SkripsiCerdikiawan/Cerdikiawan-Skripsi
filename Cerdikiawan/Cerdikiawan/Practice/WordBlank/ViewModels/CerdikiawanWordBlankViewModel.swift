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
    @Published var wordArrangement: [WordBlankLetterEntity]
    @Published var state: CerdikiawanWordBlankContainerState
    
    let character: CharacterEntity
    @Published var characterDialogueState: CerdikiawanCharacterDialogueContainerState
    @Published var characterDialogue: String
    
    @Published var isCorrect: Bool
    
    init(
        page: PageEntity,
        data: WordBlankEntity,
        character: CharacterEntity
    ) {
        self.page = page
        self.data = data
        
        self.word = ""
        self.wordArrangement = []
        self.state = .answering
        
        self.character = character
        self.characterDialogueState = .normal
        self.characterDialogue = "Sentuh dan susun kata yang sesuai!"
        self.isCorrect = false
    }
    
    // Function to handle user tap on a letter
    func handleTap(char: WordBlankLetterEntity) {
        if let index = wordArrangement.firstIndex(where: { $0.id == char.id }) {
            // If letter is already selected, remove letter
            wordArrangement.remove(at: index)
        }
        else {
            // else if not selected, append letter
            wordArrangement.append(char)
        }
        word = wordArrangement.map({ $0.letter }).joined()
        
        // Set state whenever user has inputted letter or not
        if word.isEmpty {
            characterDialogueState = .normal
        }
        else {
            characterDialogueState = .checkAnswer
        }
    }
    
    // Function to determine Container Type
    func determineType(state: CerdikiawanWordBlankContainerState) -> CerdikiawanLetterContainerState {
        switch state {
        case .answering:
            return .normal
        case .feedback:
            if isCorrect {
                return .correct
            }
            else {
                return .incorrect
            }
        }
    }
    
    // Function to determine button type
    func determineType(char: WordBlankLetterEntity) -> CerdikiawanLetterChoiceButtonType {
        switch state {
        case .answering:
            if wordArrangement.contains(where: { $0.id == char.id }) {
                return .selected
            }
        case .feedback:
            let letter = Character(char.letter)
            if data.correctAnswerWord.uppercased().contains(letter.uppercased()) {
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
        debugPrint("\(self.word.uppercased()) == \(data.correctAnswerWord.uppercased())")
        // Validate answer
        self.isCorrect = self.word.uppercased() == data.correctAnswerWord.uppercased()
        
        debugPrint(isCorrect)
        
        if isCorrect {
            self.characterDialogueState = .correct
            self.characterDialogue = data.feedback.correctFeedback
        }
        else {
            self.characterDialogueState = .incorrect
            self.characterDialogue = data.feedback.incorrectFeedback
        }
    }
}
