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
    
    var onContinueButtonAction: (Bool) -> Void
    
    init(
        page: PageEntity,
        data: WordMatchEntity,
        avatar: AvatarEntity,
        onContinueButtonAction: @escaping (Bool) -> Void
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                page: page,
                data: data,
                avatar: avatar
            )
        )
        self.onContinueButtonAction = onContinueButtonAction
    }
    
    var body: some View {
        VStack {
            ScrollView {
                CerdikiawanWordMatchContainer(viewModel: viewModel)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            
            CerdikiawanAvatarDialogueContainer(
                page: viewModel.page,
                avatar: viewModel.avatar,
                dialogue: viewModel.avatarDialogue,
                state: viewModel.avatarDialogueState,
                checkAnswerAction: {
                    viewModel.validateAnswer()
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
                avatar: .mock()[2],
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
