//
//  CerdikiawanReportView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import SwiftUI

struct CerdikiawanReportView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: ReportDataViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                storyRepository: SupabaseStoryRepository.shared,
                attemptRepository: SupabaseAttemptRepository.shared
            )
        )
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    Text("Laporan")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cWhite))
                    Text("Lihat perkembangan pemahaman membaca disini")
                        .font(.callout)
                        .foregroundStyle(Color(.cWhite))
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                VStack {
                    Image(systemName: "person.circle")
                        .foregroundStyle(Color(.cWhite))
                        .font(.title)
                        .fontWeight(.bold)
                        .onTapGesture {
                            appRouter.push(.profile)
                        }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tipe pemahaman membaca")
                            .font(.body)
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 4) {
                            if let reportData = viewModel.reportData {
                                CerdikiawanReadingTypeRowCard(
                                    style: .top,
                                    title: "Ide Pokok",
                                    desc: "Kemampuan untuk memahami ide pokok dari sebuah bacaan",
                                    value: reportData.idePokokPercentage
                                )
                                CerdikiawanReadingTypeRowCard(
                                    style: .middle,
                                    title: "Kosakata",
                                    desc: "Kemampuan untuk memahami kosakata dalam sebuah bacaan",
                                    value: reportData.kosakataPercentage
                                )
                                CerdikiawanReadingTypeRowCard(
                                    style: .bottom,
                                    title: "Implisit",
                                    desc: "Kemampuan untuk memahami makna implisit dari sebuah bacaan",
                                    value: reportData.implisitPercentage
                                )
                            }
                            else {
                                Text("No data available...")
                                    .font(.body)
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    VStack {
                        if let reportData = viewModel.reportData {
                            CerdikiawanReportSummary(
                                value: reportData.summaryPercentage,
                                status: reportData.summary
                            )
                        }
                        else {
                            Text("No data available...")
                                .font(.body)
                                .foregroundStyle(Color(.secondaryLabel))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text("Laporan setiap bacaan")
                            .font(.body)
                            .foregroundStyle(Color(.secondaryLabel))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 32) {
                            if viewModel.levelList.isEmpty == false {
                                ForEach(viewModel.levelList, id: \.id) { level in
                                    CerdikiawanReportLevelSelectionContainer(level: level)
                                }
                            }
                            else {
                                Text("No Level Data")
                                    .font(.body)
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .safeAreaPadding(.horizontal, 16)
                .safeAreaPadding(.vertical, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.cGray))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16
                )
            )
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .scrollIndicators(.hidden)
        }
        .background(
            Color(.cDarkBlue)
                .ignoresSafeArea(.container, edges: .top)
        )
        .onAppear() {
            Task {
                try await viewModel.setup()
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
                CerdikiawanReportView()
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
