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
                    .frame(alignment: .top)
                }
            }
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    @Previewable
    @State var levelEntity: LevelEntity = .mock()[0]
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                if let first = LevelEntity.mock().first {
                    CerdikiawanLevelSelectionContainer(
                        level: levelEntity
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
    .onAppear() {
        levelEntity.stories.append(contentsOf: StoryEntity.mock())
    }
}
