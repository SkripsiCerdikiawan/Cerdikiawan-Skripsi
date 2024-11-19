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
                                debugPrint("Pair questionID \(question.id) is pressed")
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
                            type: .filled,
                            onTap: {
                                debugPrint("Answer: \(answer.content) pressed")
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
    
    private func determineType(questionID: String) -> CerdikiawanWordMatchTextContainerType {
        switch state {
        case .answering:
            if pair[questionID] != nil {
                return .filled
            }
        case .feedback:
            return .correct
        }
        
        return .blank
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
