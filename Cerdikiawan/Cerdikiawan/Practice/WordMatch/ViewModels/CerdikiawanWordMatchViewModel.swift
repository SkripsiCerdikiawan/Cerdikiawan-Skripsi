//
//  C.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanWordMatchViewModel: ObservableObject {
    var data: WordMatchEntity
    @Published var pair: [String : WordMatchTextEntity] // Question ID : Entity
    @Published var answerPool: [WordMatchTextEntity]
    @Published var state: CerdikiawanWordMatchContainerState
    
    @Published private var selectedAnswer: WordMatchTextEntity?
    
    init(data: WordMatchEntity) {
        self.data = data
        self.pair = [:]
        self.answerPool = data.answers
        self.state = .answering
    }
    
    func determineType(answerID: String) -> CerdikiawanWordMatchTextContainerType {
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
    
    func determineType(questionID: String) -> CerdikiawanWordMatchTextContainerType {
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
    
    func handleTapFromPair(question: WordMatchTextEntity){
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
    
    func handleTapFromPool(answer: WordMatchTextEntity) {
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
