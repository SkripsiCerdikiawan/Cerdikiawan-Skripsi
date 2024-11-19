//
//  CerdikiawanReportLevelSelectionContainer.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

import SwiftUI

struct CerdikiawanReportLevelSelectionContainer: View {
    var level: ReportLevelEntity
    
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
                        CerdikiawanReportLevelCard(
                            imageName: story.storyImageName,
                            title: story.storyName,
                            description: story.storyDescription,
                            style: story.attemptStatus ? .havePlay : .neverPlay,
                            onTapGesture: {
                                // TODO: Add App Router here to navigate to report detail
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
        VStack {
            if let first = ReportLevelEntity.mock().first {
                CerdikiawanReportLevelSelectionContainer(level: first)
            }
        }
        .safeAreaPadding(16)
    }
}
