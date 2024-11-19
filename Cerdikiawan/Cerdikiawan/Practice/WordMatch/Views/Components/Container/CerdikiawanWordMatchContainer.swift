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
                                interactFromPair(question: question)
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
                                interactFromPool(answer: answer)
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
        switch state {
        case .answering:
            guard let selectedAnswer = selectedAnswer else {
                return .answer
            }
            if selectedAnswer.id == answerID {
                return .filled
            }
        case .feedback:
            return .disabled
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
            guard let answerID = pair[questionID]?.id,
                  let answerKey = data.pair[questionID] else {
                return .incorrect
            }
            
            if answerID == answerKey {
                return .correct
            }

            return .incorrect
        }
    }
    
    private func interactFromPair(question: WordMatchTextEntity){
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
            
            guard let answer = pair[question.id] else {
                return
            }
            
            // If both answer already in pair, replace each other
            if let oldQuestion = pair.first(where: {
                $1.id == selectedAnswer.id
            })?.key {
                pair[question.id] = selectedAnswer
                pair[oldQuestion] = answer
            }
            else {
                // if one answer is in answer pool, swap from answer pool to pair
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
        // If question don't have answer pair, put selected answer into pair
        else {
            guard let selectedAnswer = selectedAnswer else {
                return
            }
            
            // if selected answer already inserted, move answer
            if let oldQuestion = pair.first(where: {
                $1.id == selectedAnswer.id
            })?.key {
                pair[oldQuestion] = nil
                pair[question.id] = selectedAnswer
            }
            else {
                // If selected answer not inserted, put answer into pair
                pair[question.id] = selectedAnswer
                answerPool.removeAll(where: { $0.id == selectedAnswer.id })
            }
            self.selectedAnswer = nil
        }

    }
    
    private func interactFromPool(answer: WordMatchTextEntity) {
        if selectedAnswer == nil {
            // If there's no selected answer, set selected answer
            selectedAnswer = answer
        }
        else {
            // Validate Selected Answer is not nil
            guard let selectedAnswer = selectedAnswer else {
                return
            }
            
            // If selected answer is pressed again. unselect it
            guard selectedAnswer.id != answer.id else {
                self.selectedAnswer = nil
                return
            }
            
            // If either selected answer or new answer is from the answer pool, set new selected answer
            guard !answerPool.contains(selectedAnswer) || !answerPool.contains(answer) else {
                self.selectedAnswer = answer
                return
            }
            
            // Validate that the selected answer is from pair
            guard let question = pair.first(where: { $1.id == selectedAnswer.id })?.key,
                let pairAnswer = pair[question] else {
                return
            }
            
            // Swap the answer position
            answerPool.append(pairAnswer)
           
            if let firstIndex = answerPool.firstIndex(of: pairAnswer),
               let secondIndex = answerPool.firstIndex(of: answer) {
                answerPool.swapAt(firstIndex, secondIndex)
            }
            
            pair[question] = answer
            answerPool.removeAll(where: { $0.id == answer.id})
            
            self.selectedAnswer = nil

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
            
            Spacer()
            
            CerdikiawanButton(
                type: pair.values.count < 3 ? .disabled : .primary,
                label: "Change State",
                action: {
                    state = .feedback
                }
            )
        }
        .padding(16)
    }
}
