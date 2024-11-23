//
//  CerdikiawanWordMatchView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import SwiftUI

struct CerdikiawanWordMatchView: View {
    @EnvironmentObject var appRouter: AppRouter
    @StateObject var viewModel: CerdikiawanWordMatchViewModel
    
    var onValidateAction: (() -> Void)?
    var onContinueButtonAction: (Bool) -> Void
    
    init(
        page: PageEntity,
        data: WordMatchEntity,
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
                CerdikiawanWordMatchContainer(viewModel: viewModel)
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
            .onChange(of: viewModel.pair.values.count) { oldValue, newValue in
                viewModel.updateDialogueState()
            }
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
            CerdikiawanWordMatchView(
                page: .mock()[0],
                data: .mock()[0],
                character: .mock()[2],
                onValidateAction: {
                    debugPrint("On Validate Action")
                },
                onContinueButtonAction: { result in
                    debugPrint("Result status: \(result)")
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
