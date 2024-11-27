//
//  CerdikiawanRecordView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 27/11/24.
//

import SwiftUI

struct CerdikiawanRecordView: View {
    @StateObject private var viewModel: CerdikiawanRecordViewModel
    
    var onFinishRecordingAction: (() -> Void)?
    var onContinueButtonAction: () -> Void
    
    init(
        story: StoryEntity,
        character: CharacterEntity,
        onFinishRecordingAction: (() -> Void)? = nil,
        onContinueButtonAction: @escaping () -> Void
    ){
        _viewModel = .init(wrappedValue: .init(
            story: story,
            character: character
        ))
        self.onContinueButtonAction = onContinueButtonAction
        self.onFinishRecordingAction = onFinishRecordingAction
    }
    
    var body: some View {
        VStack {
            if viewModel.storySnapshotList.count > 0 {
                CerdikiawanRecordContainer(
                    storySnapshot: viewModel.storySnapshotList,
                    state: viewModel.recordState,
                    isPlaying: $viewModel.isPlaying,
                    onRecordButtonPressed: {
                        viewModel.handleRecord()
                    },
                    onStopButtonPressed: {
                        viewModel.handleStopRecord()
                    },
                    onReplayButtonPressed: {
                        viewModel.handleReplay()
                    },
                    onPauseButtonPressed: {
                        viewModel.handlePause()
                    },
                    onReRecordButtonPressed: {
                        viewModel.handleRerecord()
                    }
                )
                
                Spacer()
                
                VStack(spacing: 16) {
                    CerdikiawanCharacterDialogue(
                        character: viewModel.character,
                        state: viewModel.characterState.characterState,
                        message: viewModel.characterState.message
                    )
                    
                    CerdikiawanButton(
                        type: viewModel.characterState.buttonState,
                        label: "Lanjutkan",
                        action: {
                            onContinueButtonAction()
                        }
                    )
                }
            }
            else {
                ProgressView()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .safeAreaPadding(.horizontal, 16)
        .onAppear() {
            self.viewModel.setup()
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanRecordView(
                story: .mock()[0],
                character: .mock()[0],
                onFinishRecordingAction: {
                    debugPrint("Finish Recording Action")
                },
                onContinueButtonAction: {
                    debugPrint("Continue Button Pressed!")
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
