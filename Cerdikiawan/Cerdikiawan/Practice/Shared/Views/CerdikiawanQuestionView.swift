//
//  CerdikiawanQuestionView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 23/11/24.
//

import SwiftUI

struct CerdikiawanQuestionView: View {
    @StateObject private var viewModel: QuestionViewModel
    
    @Binding var currentProgress: Int
    var onQuestionAnswered: (Bool) -> Void
    
    init(
        data: PracticeEntity,
        character: CharacterEntity,
        currentProgress: Binding<Int>,
        onQuestionAnswered: @escaping (Bool) -> Void
    ) {
        _viewModel = .init(wrappedValue: .init(data: data, character: character))
        _currentProgress = .init(projectedValue: currentProgress)
        self.onQuestionAnswered = onQuestionAnswered
    }
    
    var body: some View {
        VStack {
            // Display readings first
            if viewModel.readingDisplayed == false {
                VStack {
                    CerdikiawanPageView(page: viewModel.data.page)
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if viewModel.continueButtonDisabled {
                            Text("Dapat melanjutkan dalam \(viewModel.readingTimeSecond) detik...")
                                .font(.callout)
                                .foregroundStyle(Color(.cDarkOrange))
                        }
                        CerdikiawanButton(
                            type: viewModel.continueButtonDisabled ? .disabled : .primary,
                            label: "Lanjutkan",
                            action: {
                                viewModel.handleDisplayQuestion()
                            }
                        )
                    }
                }
                .onAppear() {
                    viewModel.startReadingCountDown()
                }
            }
            // Display question after displaying readings
            else {
                VStack {
                    switch viewModel.data.question {
                    case let wordMatch as WordMatchEntity:
                        VStack {
                            CerdikiawanWordMatchView(
                                page: viewModel.data.page,
                                data: wordMatch,
                                character: viewModel.character,
                                onValidateAction: {
                                    currentProgress += 1
                                },
                                onContinueButtonAction: { result in
                                    onQuestionAnswered(result)
                                }
                            )
                        }
                        
                    case let wordBlank as WordBlankEntity:
                        VStack {
                            CerdikiawanWordBlankView(
                                page: viewModel.data.page,
                                data: wordBlank,
                                character: viewModel.character,
                                onValidateAction: {
                                    currentProgress += 1
                                },
                                onContinueButtonAction: { result in
                                    onQuestionAnswered(result)
                                }
                            )
                        }
                        
                    case let multipleChoice as MultipleChoiceEntity:
                        VStack {
                            CerdikiawanMultipleChoiceView(
                                page: viewModel.data.page,
                                data: multipleChoice,
                                character: viewModel.character,
                                onValidateAction: {
                                    currentProgress += 1
                                },
                                onContinueButtonAction: { result in
                                    onQuestionAnswered(result)
                                }
                            )
                        }
                        
                    default:
                        Text("Error! Is not a Cerdikiawan Question")
                            .font(.body)
                            .foregroundStyle(Color(.secondaryLabel))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .safeAreaPadding(.horizontal, 16)
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    @Previewable
    @StateObject var sessionData: SessionData = .init(
        authRepository: SupabaseAuthRepository.shared,
        profileRepository: SupabaseProfileRepository.shared
    )
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanQuestionView(
                    data: .mock()[0],
                    character: .mock()[1],
                    currentProgress: .constant(0),
                    onQuestionAnswered: { isCorrect in
                        debugPrint("Is Correct: \(isCorrect)")
                    }
                )
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
    }
    .environmentObject(appRouter)
    .environmentObject(sessionData)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
    .onAppear() {
        sessionData.user = .mock()[0]
    }
}
