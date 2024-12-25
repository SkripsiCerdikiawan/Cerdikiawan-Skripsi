//
//  CerdikiawanResultView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import SwiftUI

struct CerdikiawanResultView: View {
    @EnvironmentObject var sessionData: SessionData
    @StateObject private var viewModel: ResultDataViewModels
    var onCompletionTap: () -> Void
    
    init(
        character: CharacterEntity,
        resultData: ResultDataEntity,
        onCompletionTap: @escaping () -> Void
    ){
        _viewModel = .init(wrappedValue: .init(
            character: character,
            resultEntity: resultData,
            attemptRepository: SupabaseAttemptRepository.shared,
            profileRepository: SupabaseProfileRepository.shared,
            recordRepository: SupabaseRecordSoundStorageRepository.shared
        ))
        self.onCompletionTap = onCompletionTap
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    Text("Hore! Bacaan selesai!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cWhite))
                    Text("Yuk, kita lihat bagaimana perkembangan kamu di bacaan ini")
                        .font(.callout)
                        .foregroundStyle(Color(.cWhite))
                }
                .padding(.trailing, 8)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            VStack {
                ScrollView {
                    VStack(spacing: 8) {
                        Text("Laporan pemahaman membaca")
                            .font(.body)
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        CerdikiawanResultData(result: viewModel.resultEntity)
                    }
                    .safeAreaPadding(.horizontal, 16)
                    .safeAreaPadding(.top, 32)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
                .scrollIndicators(.hidden)
                
                VStack(spacing: 16) {
                    CerdikiawanCharacterDialogue(
                        character: viewModel.character,
                        state: .happy,
                        message: "Kerja bagus menyelesaikan bacaan!"
                    )
                    
                    CerdikiawanButton(
                        type: viewModel.determineButtonState(),
                        label: "Kembali ke halaman awal",
                        action: {
                            viewModel.connectDBStatus = true
                            Task {
                                if let userId = sessionData.user?.id, let userBalance = sessionData.user?.balance {
                                    if try await viewModel.saveAttemptData(userID: userId, userBalance: userBalance) {
                                        sessionData.user?.balance += viewModel.resultEntity.correctCount * viewModel.resultEntity.baseBalance
                                        onCompletionTap()
                                    }
                                }
                                else {
                                    viewModel.connectDBStatus = false
                                }
                            }
                        }
                    )
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.cGray))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16
                )
            )
        }
        .background(
            Color(.cDarkBlue)
                .ignoresSafeArea(.container, edges: .top)
        )
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
                CerdikiawanResultView(
                    character: .mock()[0],
                    resultData: ResultDataEntity.mock()[1],
                    onCompletionTap: {
                        debugPrint("Complete...")
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
