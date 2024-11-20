//
//  CerdikiawanWordBlankContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 18/11/24.
//

import SwiftUI

struct CerdikiawanWordBlankContainer: View {
    // CONSTANT
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    var data: WordBlankEntity
    
    @Binding var word: String
    @Binding var wordArrangement: [WordBlankCharacterEntity]
    @Binding var state: CerdikiawanWordBlankContainerState
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(data.question)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            CerdikiawanCharacterContainer(
                value: $word,
                state: determineType(state: state)
            )
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(data.characters, id: \.id, content: { char in
                    CerdikiawanCharacterChoiceButton(
                        label: char.character,
                        type: determineType(char: char),
                        action: {
                            self.interact(with: char)
                        }
                    )
                    .disabled(state == .feedback)
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    // Function to determine Container Type
    private func determineType(state: CerdikiawanWordBlankContainerState) -> CerdikiawanCharacterContainerState {
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
    private func determineType(char: WordBlankCharacterEntity) -> CerdikiawanCharacterChoiceButtonType {
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
    
    private func interact(with char: WordBlankCharacterEntity) {
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
}

#Preview {
    @Previewable @State var wordArrangement: [WordBlankCharacterEntity] = []
    @Previewable @State var word: String = ""
    @Previewable @State var state: CerdikiawanWordBlankContainerState = .answering
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanWordBlankContainer(
                data: .mock()[0],
                word: $word,
                wordArrangement: $wordArrangement,
                state: $state
            )
            
            Spacer()
            
            CerdikiawanButton(
                label: "Change State",
                action: {
                    state = .feedback
                }
            )
        }
        .padding(16)
    }
}
