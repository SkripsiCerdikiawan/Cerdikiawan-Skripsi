//
//  CerdikiawanQuestionView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import SwiftUI

struct CerdikiawanStoryView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: StoryViewModel
    
    init (
        story: StoryEntity
    ) {
        _viewModel = .init(wrappedValue: .init(story: story))
    }
    
    var body: some View {
        VStack {
            VStack {
                self.build(character: viewModel.userCharacter)
            }
            .safeAreaPadding(.horizontal, 16)
        }
        .onAppear {
            if let user = sessionData.user {
                viewModel.setup(userID: user.id)
            }
            else {
                fatalError("User ID is not defined here!")
            }
        }
    }
    
    // MARK: - This function is used to display story and passage
    @ViewBuilder
    func build(character: CharacterEntity?) -> some View {
        if let question = viewModel.practiceList.last {
            // If passage has been displayed, show question
            if viewModel.passageDisplayed {
                switch question.question {
                case let wordMatch as WordMatchEntity:
                    VStack {
                        CerdikiawanWordMatchView(
                            page: question.page,
                            data: wordMatch,
                            character: character ?? .mock()[0],
                            onContinueButtonAction: { result in
                                viewModel.handleNext(result: result)
                            }
                        )
                    }
                    
                case let wordBlank as WordBlankEntity:
                    VStack {
                        CerdikiawanWordBlankView(
                            page: question.page,
                            data: wordBlank,
                            character: character ?? .mock()[0],
                            onContinueButtonAction: { result in
                                viewModel.handleNext(result: result)
                            }
                        )
                    }
                    
                case let multipleChoice as MultipleChoiceEntity:
                    VStack {
                        CerdikiawanMultipleChoiceView(
                            page: question.page,
                            data: multipleChoice,
                            character: character ?? .mock()[0],
                            onContinueButtonAction: { result in
                                viewModel.handleNext(result: result)
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
            // else if passage has not been displayed, show the passage
            else {
                VStack {
                    CerdikiawanPageView(page: question.page)
                    Spacer()
                    CerdikiawanButton(
                        type: .primary,
                        label: "Lanjutkan",
                        action: {
                            viewModel.handleNext()
                        }
                    )
                }
            }
        }
        else {
            Text("Error! No Story Data")
                .font(.body)
                .foregroundStyle(Color(.secondaryLabel))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    @Previewable
    @StateObject var sessionData: SessionData = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanStoryView(story: .mock()[0])
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
