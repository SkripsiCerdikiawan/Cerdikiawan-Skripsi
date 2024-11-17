//
//  CerdikiawanLevelSelectionContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanLevelSelectionContainer: View {
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
                                // TODO: Add App Router here to navigate to passage
                                debugPrint("Story \(story.storyName) is pressed")
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
    ZStack {
        Color(.cGray).ignoresSafeArea()
        if let first = LevelEntity.mock().first {
            CerdikiawanLevelSelectionContainer(
                level: first
            )
            .safeAreaPadding(.horizontal, 16)
        }
        
    }
}
