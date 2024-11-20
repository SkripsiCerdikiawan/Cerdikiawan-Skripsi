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
    
    @ObservedObject var viewModel: CerdikiawanWordMatchViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(viewModel.data.prompt)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 12) {
                ForEach(viewModel.data.questions, id: \.id) { question in
                    HStack(spacing: 12) {
                        // Question Section
                        CerdikiawanWordMatchTextContainer(
                            label: question.content,
                            type: .question
                        )
                        
                        // Answer Section
                        CerdikiawanWordMatchTextContainer(
                            label: viewModel.pair[question.id]?.content ?? "",
                            type: viewModel.determineType(questionID: question.id),
                            onTap: {
                                viewModel.handleTapFromPair(question: question)
                            }
                        )
                        .disabled(viewModel.state == .feedback)
                    }
                }
            }
            
            // Answer Pool
            VStack(alignment: .leading, spacing: 8) {
                Text("Pilihan Jawaban")
                    .font(.body)
                    .foregroundStyle(Color(.secondaryLabel))
                
                LazyVGrid(columns: columns, content: {
                    ForEach(viewModel.answerPool, id: \.id, content: { answer in
                        CerdikiawanWordMatchTextContainer(
                            label: answer.content,
                            type: viewModel.determineType(answerID: answer.id),
                            onTap: {
                                viewModel.handleTapFromPool(answer: answer)
                            }
                        )
                        .disabled(viewModel.state == .feedback)
                    })
                })
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    @Previewable
    @StateObject var viewModel = CerdikiawanWordMatchViewModel(data: .mock()[0])
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanWordMatchContainer(
                viewModel: viewModel
            )
            
            Spacer()
            
            CerdikiawanButton(
                type: viewModel.pair.values.count < 3 ? .disabled : .primary,
                label: "Change State",
                action: {
                    viewModel.state = .feedback
                }
            )
        }
        .padding(16)
    }
}
