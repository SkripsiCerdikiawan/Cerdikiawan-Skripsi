//
//  CerdikiawanWordBlankView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import SwiftUI

struct CerdikiawanWordBlankView: View {
    @StateObject var viewModel: CerdikiawanWordBlankViewModel
    
    var onValidateAction: (() -> Void)?
    var onContinueButtonAction: (Bool) -> Void
    
    init(
        page: PageEntity,
        data: WordBlankEntity,
        character: CharacterEntity,
        onValidateAction: (() -> Void)? = nil,
        onContinueButtonAction: @escaping (Bool) -> Void
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                page: page,
                data: data,
                character: character
            )
        )
        self.onContinueButtonAction = onContinueButtonAction
        self.onValidateAction = onValidateAction
    }
    
    var body: some View {
        VStack {
            ScrollView {
                CerdikiawanWordBlankContainer(viewModel: viewModel)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            
            CerdikiawanCharacterDialogueContainer(
                page: viewModel.page,
                character: viewModel.character,
                dialogue: viewModel.characterDialogue,
                state: viewModel.characterDialogueState,
                checkAnswerAction: {
                    viewModel.validateAnswer()
                    onValidateAction?()
                },
                continueAction: {
                    onContinueButtonAction(viewModel.isCorrect)
                }
            )
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanWordBlankView(
                page: .mock()[0],
                data: .mock()[0],
                character: .mock()[0],
                onContinueButtonAction: { result in
                    debugPrint("Answer is correct: \(result)")
                }
            )
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.vertical, 16)
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
