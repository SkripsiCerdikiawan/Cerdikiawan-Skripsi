//
//  CerdikiawanCharacterDialogueContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import SwiftUI

struct CerdikiawanCharacterDialogueContainer: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var page: PageEntity
    var character: CharacterEntity
    var dialogue: String
    
    var state: CerdikiawanCharacterDialogueContainerState
    
    var checkAnswerAction: () -> Void
    var continueAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom, spacing: 8) {
                CerdikiawanCharacterDialogue(
                    character: character,
                    state: state.characterState,
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
        .fixedSize(horizontal: false, vertical: true)
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
    @State var state: CerdikiawanCharacterDialogueContainerState = .checkAnswer
    
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanCharacterDialogueContainer(
                page: .mock()[0],
                character: .mock()[0],
                dialogue: "Jawaban ini sesuai dengan pesan Ibu Kelinci yang meminta untuk menjaga jarak, kebersihan, dan tidak bersentuhan untuk mencegah penularan penyakit. \n\n Hal ini menunjukkan bahwa larangan tersebut adalah bentuk perlindungan, bukan semata-mata untuk melarang atau membatasi.",
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
