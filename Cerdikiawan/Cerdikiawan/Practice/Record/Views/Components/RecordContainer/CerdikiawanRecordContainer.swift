//
//  CerdikiawanRecordContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

import SwiftUI

struct CerdikiawanRecordContainer: View {
    var storySnapshot: [String]
    var state: CerdikiawanRecordContainerState
    @Binding var isPlaying: Bool
    
    var onRecordButtonPressed: () -> Void
    var onStopButtonPressed: () -> Void
    var onReplayButtonPressed: () -> Void
    var onPauseButtonPressed: () -> Void
    var onReRecordButtonPressed: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 12) {
                Text("Yuk, ceritakan kembali apa yang sudah kamu baca!")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                // Story Snapshot Container
                VStack(alignment: .leading, spacing: 4) {
                    ScrollView(.horizontal, content: {
                        HStack(spacing: 12) {
                            ForEach(storySnapshot, id: \.self) { imageName in
                                Image(uiImage: UIImage(named: imageName) ?? UIImage(imageLiteralResourceName: "NOTFOUND_IMAGE"))
                                    .resizable()
                                    .frame(width: 300, height: 150)
                            }
                        }
                    })
                    .scrollIndicators(.hidden)
                    Text("Cuplikan cerita")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            
            VStack {
                build()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func build() -> some View {
        switch state {
        case .start:
            HStack {
                CerdikiawanRecordButton(
                    type: .normal,
                    onTapAction: {
                        onRecordButtonPressed()
                    }
                )
            }
        case .recording:
            HStack {
                CerdikiawanRecordButton(
                    type: .recording,
                    onTapAction: {
                        onStopButtonPressed()
                    }
                )
            }
        case .review:
            HStack(alignment: .top, spacing: 24) {
                CerdikiawanRecordButton(
                    type: isPlaying ? .pause : .replay,
                    onTapAction: {
                        if isPlaying {
                            onPauseButtonPressed()
                        }
                        else {
                            onReplayButtonPressed()
                        }
                    }
                )
                
                CerdikiawanRecordButton(
                    type: .rerecord,
                    onTapAction: {
                        onReRecordButtonPressed()
                    }
                )
            }
        }
    }
}

#Preview {
    @Previewable
    @State var isPlaying: Bool = false
    
    @Previewable
    @State var state = CerdikiawanRecordContainerState.start
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanRecordContainer(
                storySnapshot: [
                    "DEBUG_IMAGE", "DEBUG_IMAGE", "DEBUG_IMAGE"
                ],
                state: state,
                isPlaying: $isPlaying,
                onRecordButtonPressed: {
                    debugPrint("Record Button Pressed")
                },
                onStopButtonPressed: {
                    debugPrint("Stop Button Pressed")
                },
                onReplayButtonPressed: {
                    isPlaying = true
                    debugPrint("Replay Button Pressed")
                },
                onPauseButtonPressed: {
                    isPlaying = false
                    debugPrint("Pause Button Pressed")
                },
                onReRecordButtonPressed: {
                    isPlaying = false
                    debugPrint("Rerecord Button Pressed")
                }
            )
            
            CerdikiawanButton(label: "Change State", action: {
                var flag = false
                for data in CerdikiawanRecordContainerState.allCases {
                    if state == data {
                        flag = true
                    }
                    else if flag {
                        state = data
                        break
                    }
                }
            })
        }
        .safeAreaPadding(16)
    }
}
