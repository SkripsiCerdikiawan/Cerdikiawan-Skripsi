//
//  CerdikiawanResultView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import SwiftUI

struct CerdikiawanResultView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: ResultDataViewModels
    
    init(
        character: CharacterEntity,
        resultData: ResultDataEntity
    ){
        _viewModel = .init(wrappedValue: .init(
            character: character,
            resultEntity: resultData
        ))
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
                        label: "Kembali ke halaman awal",
                        action: {
                            if let user = sessionData.user {
                                let dataSaved = viewModel.saveAttemptData(userID: user.id)
                                if dataSaved {
                                    appRouter.popToRoot()
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
    @StateObject var sessionData: SessionData = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanResultView(
                    character: .mock()[0],
                    resultData: ResultDataEntity.mock()[1]
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
