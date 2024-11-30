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
        VStack(spacing: 8) {
            if viewModel.questionList.isEmpty == false {
                CerdikiawanProgressBar(
                    minimum: 0,
                    maximum: Double(viewModel.questionList.count + 1),
                    value: $viewModel.currentPageIdx
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                if viewModel.questionAnsweredFlag {
                    CerdikiawanRecordView(
                        story: viewModel.story,
                        character: viewModel.userCharacter ?? .mock()[0],
                        onContinueButtonAction: {
                            viewModel.currentPageIdx += 1
                            viewModel.handleNext()
                        }
                    )
                }
                else if let question = viewModel.activeQuestion {
                    CerdikiawanQuestionView(
                        data: question,
                        character: viewModel.userCharacter ?? .mock()[0],
                        currentProgress: $viewModel.currentPageIdx,
                        onQuestionAnswered: { isCorrect in
                            viewModel.handleNext(
                                isCorrect: isCorrect
                            )
                        }
                    )
                    .id(question.id)
                }
                else {
                    Text("Error! No Active Question Data")
                        .font(.body)
                        .foregroundStyle(Color(.secondaryLabel))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle(viewModel.story.storyName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(
                    action: {
                        appRouter.popToRoot()
                    },
                    label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(.cDarkRed))
                    }
                )
            })
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .safeAreaPadding(.top, 8)
        .onAppear {
            if let user = sessionData.user {
                viewModel.setup(
                    userID: user.id,
                    appRouter: appRouter
                )
            }
            else {
                fatalError("User ID is not defined here!")
            }
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