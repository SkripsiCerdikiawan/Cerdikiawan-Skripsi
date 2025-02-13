//
//  CerdikiawanReportLevelSelectionContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

import SwiftUI

struct CerdikiawanReportLevelSelectionContainer: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var level: ReportLevelEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                switch(level.level) {
                    case 1:
                    Text("Tingkatan Mudah")
                        .font(.title2)
                        .fontWeight(.semibold)
                    case 2:
                    Text("Tingkatan Sedang")
                        .font(.title2)
                        .fontWeight(.semibold)
                    case 3:
                    Text("Tingkatan Sulit")
                        .font(.title2)
                        .fontWeight(.semibold)
                    default:
                    Text("Tingkatan Cerita")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Text(level.levelDescription)
                    .font(.subheadline)
            }
            
            ScrollView(.horizontal) {
                HStack(alignment: .top) {
                    ForEach(level.stories, id: \.storyId, content: { story in
                        CerdikiawanReportLevelCard(
                            imageName: story.storyImageName,
                            title: story.storyName,
                            description: story.storyDescription,
                            style: story.attemptStatus ? .havePlay : .neverPlay,
                            onTapGesture: {
                                if story.attemptStatus {
                                    appRouter.push(.reportDetail(report: story))
                                }
                            }
                        )
                    })
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                if let first = ReportLevelEntity.mock().first {
                    CerdikiawanReportLevelSelectionContainer(level: first)
                }
            }
            .safeAreaPadding(16)
        }
        .navigationDestination(for: Screen.self, destination: { screen in
            appRouter.build(screen)
        })
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
