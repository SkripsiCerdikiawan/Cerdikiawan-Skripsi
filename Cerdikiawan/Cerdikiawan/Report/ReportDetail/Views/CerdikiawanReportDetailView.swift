//
//  CerdikiawanReportDetailView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import SwiftUI

struct CerdikiawanReportDetailView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: CerdikiawanReportDetailViewModel
    
    init(story: ReportStoryEntity) {
        _viewModel = .init(
            wrappedValue: .init(
                story: story
            )
        )
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 32) {
                VStack (alignment: .leading, spacing: 8) {
                    Text("Data Bacaan")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    VStack(spacing: 4) {
                        CerdikiawanReportDetailInformationRow(
                            label: "Level",
                            content: "1",
                            style: .top
                        )
                        CerdikiawanReportDetailInformationRow(
                            label: "Topik",
                            content: "Perjalanan Budi ke Pasar",
                            style: .middle
                        )
                        CerdikiawanReportDetailInformationRow(
                            label: "Deskripsi",
                            content: "Cerita ini menceritakan mengenai bagaimana pengalaman budi berjalan ke pasar",
                            style: .bottom
                        )
                    }
                }
                VStack (alignment: .leading, spacing: 8) {
                    Text("Percobaan yang dilakukan")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.fetchAttempts(), id: \.attemptId) { value in
                                CerdikiawanAttemptCard(date: value.date,
                                                       kosakataPercentage: value.kosakataPercentage,
                                                       idePokokPercentage: value.idePokokPercentage,
                                                       implisitPercentage: value.implisitPercentage,
                                                       buttonStyle: value.attemptId == viewModel.currentlyPlayedAttemptId ? .secondary : .primary,
                                                       onTapButtonAction: {
                                    viewModel.currentlyPlayedAttemptId = value.attemptId
                                    viewModel.playRecordSound() // TODO: Play record sound
                                })
                            }
                        }
                    }
                }
            }
        }
        .safeAreaPadding(.top, 12)
        .navigationTitle("Laporan Detail")
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
                CerdikiawanReportDetailView(story: ReportStoryEntity.mock()[0])
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.vertical, 16)
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
