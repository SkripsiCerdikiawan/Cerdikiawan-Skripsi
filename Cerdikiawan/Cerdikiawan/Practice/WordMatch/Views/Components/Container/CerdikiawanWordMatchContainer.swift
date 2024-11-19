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
                                if let selectedAnswer = selectedAnswer {
                                    pair[question.id] = selectedAnswer
                                    self.selectedAnswer = nil
                                    answerPool.removeAll(where: { $0.id == selectedAnswer.id})
                                }
                                else if let answer = pair[question.id] {
                                    answerPool.append(answer)
                                    pair[question.id] = nil
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
                                if selectedAnswer == nil {
                                    debugPrint("Selected Answer: \(answer.content)")
                                    selectedAnswer = answer
                                }
                                else {
                                    guard let selected = selectedAnswer,
                                          selected.id != answer.id else {
                                        debugPrint("Selected Answer: nil")
                                        selectedAnswer = nil
                                        return
                                    }
                                    
                                    selectedAnswer = answer
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
            guard pair[questionID] != nil else {
                if selectedAnswer != nil {
                    return .blank
                }
                return .question
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
