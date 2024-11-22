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
    
    @ObservedObject var viewModel: CerdikiawanWordBlankViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(viewModel.data.question)")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
            CerdikiawanLetterContainer(
                value: $viewModel.word,
                state: viewModel.determineType(state: viewModel.state)
            )
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.data.letters, id: \.id, content: { char in
                    CerdikiawanLetterChoiceButton(
                        label: char.letter,
                        type: viewModel.determineType(char: char),
                        action: {
                            viewModel.handleTap(char: char)
                        }
                    )
                    .disabled(viewModel.state == .feedback)
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    @Previewable @StateObject var viewModel = CerdikiawanWordBlankViewModel(
        page: .mock()[0],
        data: .mock()[0],
        character: .mock()[0]
    )
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanWordBlankContainer(
                viewModel: viewModel
            )
            
            Spacer()
            
            CerdikiawanButton(
                label: "Change State",
                action: {
                    viewModel.state = .feedback
                }
            )
        }
        .padding(16)
    }
}
