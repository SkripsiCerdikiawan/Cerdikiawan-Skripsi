//
//  CerdikiawanWordBlankViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanWordBlankViewModel: ObservableObject {
    var data: WordBlankEntity
    
    @Published var word: String
    @Published var wordArrangement: [WordBlankCharacterEntity]
    @Published var state: CerdikiawanWordBlankContainerState
    
    init(data: WordBlankEntity) {
        self.data = data
        self.word = ""
        self.wordArrangement = []
        self.state = .answering
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
}
