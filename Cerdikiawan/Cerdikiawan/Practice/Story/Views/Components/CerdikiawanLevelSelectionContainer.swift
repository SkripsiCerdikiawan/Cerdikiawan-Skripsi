//
//  CerdikiawanLevelSelectionContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanLevelSelectionContainer: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var level: LevelEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Level \(level.level)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(level.levelDescription)
                    .font(.subheadline)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(level.stories, id: \.storyId, content: { story in
                        CerdikiawanLevelSelectionCard(
                            imageName: story.storyImageName,
                            title: story.storyName,
                            description: story.storyDescription,
                            availableBalanceToGain: story.availableCoinToGain,
                            onTapGesture: {
                                appRouter.push(.practice(story: story))
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
                if let first = LevelEntity.mock().first {
                    CerdikiawanLevelSelectionContainer(
                        level: first
                    )
                    .safeAreaPadding(.horizontal, 16)
                }
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
