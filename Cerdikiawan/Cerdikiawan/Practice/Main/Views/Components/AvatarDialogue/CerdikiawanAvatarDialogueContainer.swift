//
//  CerdikiawanAvatarDialogueContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import SwiftUI

struct CerdikiawanAvatarDialogueContainer: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var page: PageEntity
    var avatar: AvatarEntity
    var dialogue: String
    
    var state: CerdikiawanAvatarDialogueContainerState
    
    var checkAnswerAction: () -> Void
    var continueAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 8) {
                CerdikiawanAvatarDialogue(
                    avatar: avatar,
                    state: state.avatarState,
                    message: dialogue
                )
                Spacer()
                Button(
                    action: {
                        appRouter.presentSheet(.page(page: page))
                        debugPrint("Opening sheets...")
                    },
                    label: {
                        Image(systemName: "text.page.badge.magnifyingglass")
                            .imageScale(.large)
                            .font(.system(size: 15))
                            .padding(8)
                    }
                )
                .buttonStyle(CerdikiawanOpenPageButtonStyle())
            }
            
            CerdikiawanButton(
                type: state.buttonType,
                label: state.buttonLabel,
                action: {
                    switch state {
                    case .checkAnswer:
                        checkAnswerAction()
                    case .correct:
                        continueAction()
                    case .incorrect:
                        continueAction()
                    default:
                        break
                    }
                }
            )
            
        }
        .frame(maxWidth: .infinity)
    }
}

private struct CerdikiawanOpenPageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(.cDarkOrange))
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(
                .linear(duration: 0.2),
                value: configuration.isPressed
            )
            .foregroundStyle(Color(.cWhite))
    }
}

#Preview {
    @Previewable
    @State var state: CerdikiawanAvatarDialogueContainerState = .checkAnswer
    
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanAvatarDialogueContainer(
                page: .mock()[0],
                avatar: .mock()[0],
                dialogue: "Hello World!",
                state: state,
                checkAnswerAction: {
                    switch state {
                    case .normal:
                        state = .checkAnswer
                    case .checkAnswer:
                        state = .correct
                    case .correct:
                        state = .incorrect
                    case .incorrect:
                        debugPrint("Finish")
                    }
                },
                continueAction: {
                    switch state {
                    case .normal:
                        state = .checkAnswer
                    case .checkAnswer:
                        state = .correct
                    case .correct:
                        state = .incorrect
                    case .incorrect:
                        debugPrint("Finish")
                    }
                }
            )
        }
        .safeAreaPadding(16)
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
