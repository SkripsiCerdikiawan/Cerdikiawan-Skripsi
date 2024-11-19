//
//  CerdikiawanWordMatchContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 18/11/24.
//

import SwiftUI

struct CerdikiawanWordMatchContainer: View {
    // CONSTANT
    let columns = [
        GridItem(.adaptive(minimum: 172), spacing: 8)
    ]
    
    var data: WordMatchEntity
    @Binding var pair: [String : WordMatchTextEntity] // Question ID : Entity
    @Binding var answerPool: [WordMatchTextEntity]
    @Binding var state: CerdikiawanWordMatchContainerState
    
    @State private var selectedAnswer: WordMatchTextEntity?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(data.prompt)")
                .font(.title2)
                .fontWeight(.medium)
            
            VStack(spacing: 12) {
                ForEach(data.questions, id: \.id) { question in
                    HStack(spacing: 12) {
                        // Question Section
                        CerdikiawanWordMatchTextContainer(
                            label: question.content,
                            type: .question
                        )
                        
                        // Answer Section
                        CerdikiawanWordMatchTextContainer(
                            label: pair[question.id]?.content ?? "",
                            type: determineType(questionID: question.id),
                            onTap: {
                                // if question has answer value
                                if let answer = pair[question.id] {
                                    guard let selectedAnswer = selectedAnswer else {
                                        self.selectedAnswer = answer
                                        return
                                    }
                                    
                                    // If user select answer again, deselect
                                    if selectedAnswer.id == answer.id {
                                        self.selectedAnswer = nil
                                        return
                                    }
                                    
                                    // Put Answer
                                    guard let answer = pair[question.id] else {
                                        return
                                    }
                                    
                                    // Replace if answer is already put into pair
                                    if let oldQuestion = pair.first(where: {
                                        $1.id == selectedAnswer.id
                                    })?.key {
                                        pair[question.id] = selectedAnswer
                                        pair[oldQuestion] = answer
                                    }
                                    else {
                                        // Replace to answer pool if not
                                        pair[question.id] = selectedAnswer
                                        answerPool.append(answer)
                                        
                                        // Swap the answer position
                                        if let firstIndex = answerPool.firstIndex(of: selectedAnswer),
                                           let secondIndex = answerPool.firstIndex(of: answer) {
                                            answerPool.swapAt(firstIndex, secondIndex)
                                        }
                                        
                                        answerPool.removeAll(where: { $0.id == selectedAnswer.id })
                                        
                                    }
                                    
                                    
                                    self.selectedAnswer = nil
                                    
                                }
                                // If not, put answer
                                else {
                                    guard let selectedAnswer = selectedAnswer else {
                                        return
                                    }
                                    
                                    // Check if selected answer is already inserted
                                    if let oldQuestion = pair.first(where: {
                                        $1.id == selectedAnswer.id
                                    })?.key {
                                        pair[oldQuestion] = nil
                                        pair[question.id] = selectedAnswer
                                    }
                                    else {
                                        pair[question.id] = selectedAnswer
                                        answerPool.removeAll(where: { $0.id == selectedAnswer.id })
                                    }
                                    
                                    self.selectedAnswer = nil
                                }
                                
                            }
                        )
                    }
                }
            }
            
            // Answer Pool
            VStack(alignment: .leading, spacing: 8) {
                Text("Pilihan Jawaban")
                    .font(.body)
                    .foregroundStyle(Color(.secondaryLabel))
                
                LazyVGrid(columns: columns, content: {
                    ForEach(self.answerPool, id: \.id, content: { answer in
                        CerdikiawanWordMatchTextContainer(
                            label: answer.content,
                            type: determineType(answerID: answer.id),
                            onTap: {
                                // If there's no selected answer, set selected answer
                                if selectedAnswer == nil {
                                    selectedAnswer = answer
                                }
                                else {
                                    // if any selected answer
                                    if let selectedAnswer = selectedAnswer {
                                        // If selected answer is pressed again. unselect it
                                        if selectedAnswer.id == answer.id {
                                            self.selectedAnswer = nil
                                        }
                                        else {
                                            // If selected answer is from the answer pool, swap it
                                            if let firstIndex = answerPool.firstIndex(of: selectedAnswer),
                                               let secondIndex = answerPool.firstIndex(of: answer) {
                                                answerPool.swapAt(firstIndex, secondIndex)
                                            }
                                            // If selected answer is from pair, swap it
                                            else {
                                                if let question = pair.first(where: {
                                                    $1.id == selectedAnswer.id
                                                })?.key,
                                                    let pairAnswer = pair[question] {
                                                    answerPool.append(pairAnswer)
                                                    
                                                    // Swap the answer position
                                                    if let firstIndex = answerPool.firstIndex(of: pairAnswer),
                                                       let secondIndex = answerPool.firstIndex(of: answer) {
                                                        answerPool.swapAt(firstIndex, secondIndex)
                                                    }
                                                    
                                                    pair[question] = answer
                                                    answerPool.removeAll(where: { $0.id == answer.id})
                                                    
                                                }
                                            }
                                            self.selectedAnswer = nil
                                        }
                                    }
                                    
                                    
                                }
                            }
                        )
                    })
                })
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear() {
            self.answerPool = data.answers
        }
    }
    
    private func determineType(answerID: String) -> CerdikiawanWordMatchTextContainerType {
        guard let selectedAnswer = selectedAnswer else {
            return .answer
        }
        if selectedAnswer.id == answerID {
            return .filled
        }
        return .answer
    }
    
    private func determineType(questionID: String) -> CerdikiawanWordMatchTextContainerType {
        switch state {
        case .answering:
            guard let answer = pair[questionID] else {
                if selectedAnswer != nil {
                    return .blank
                }
                return .question
            }
            
            if selectedAnswer == answer {
                return .filled
            }
            return .answer
            
        case .feedback:
            return .correct
        }
    }
}

#Preview {
    @Previewable
    @State var pair: [String : WordMatchTextEntity] = [:]
    @Previewable
    @State var state: CerdikiawanWordMatchContainerState = .answering
    @Previewable
    @State var answerPool: [WordMatchTextEntity] = []
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanWordMatchContainer(
                data: .mock()[0],
                pair: $pair,
                answerPool: $answerPool,
                state: $state
            )
        }
        .padding(16)
    }
}
