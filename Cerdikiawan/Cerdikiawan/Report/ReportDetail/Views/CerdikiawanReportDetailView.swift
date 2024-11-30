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
                story: story,
                attemptRepository: SupabaseAttemptRepository.shared,
                recordSoundRepository: SupabaseRecordSoundStorageRepository.shared
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
                            content: "\(viewModel.story.storyLevel)",
                            style: .top
                        )
                        CerdikiawanReportDetailInformationRow(
                            label: "Topik",
                            content: viewModel.story.storyName,
                            style: .middle
                        )
                        CerdikiawanReportDetailInformationRow(
                            label: "Deskripsi",
                            content: viewModel.story.storyDescription,
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
                            ForEach(viewModel.attempts, id: \.attemptId) { value in
                                CerdikiawanAttemptCard(date: value.date,
                                                       kosakataPercentage: value.kosakataPercentage,
                                                       idePokokPercentage: value.idePokokPercentage,
                                                       implisitPercentage: value.implisitPercentage,
                                                       buttonStyle: value.attemptId == viewModel.currentlyPlayedAttemptId ? .secondary : .primary,
                                                       onTapButtonAction: {
                                    if viewModel.currentlyPlayedAttemptId == value.attemptId {
                                        viewModel.stopRecordSound()
                                    } else {
                                        viewModel.currentlyPlayedAttemptId = value.attemptId
                                        Task {
                                            try await viewModel.playRecordSound()
                                        }
                                    }
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
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(.cDarkBlue))
                    }
                )
            })
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            Task {
                try await viewModel.setup(userData: sessionData.user)
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
