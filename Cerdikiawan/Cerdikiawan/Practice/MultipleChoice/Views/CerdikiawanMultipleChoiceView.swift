//
//  CerdikiawanMultipleChoiceView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import SwiftUI

struct CerdikiawanMultipleChoiceView: View {
    @StateObject var viewModel: CerdikiawanMultipleChoiceViewModel
    
    var onValidateAction: (() -> Void)?
    var onContinueButtonAction: (Bool) -> Void
    
    init(
        page: PageEntity,
        data: MultipleChoiceEntity,
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
                CerdikiawanMultipleChoiceContainer(viewModel: viewModel)
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
            CerdikiawanMultipleChoiceView(
                page: .mock()[0],
                data: .mock()[0],
                character: .mock()[1],
                onContinueButtonAction: { result in
                    debugPrint("Answer Correct Status: \(result)")
                }
            )
            .environmentObject(appRouter)
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.vertical, 16)
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
