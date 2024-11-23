//
//  StoryEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct StoryEntity {
    let storyId: String
    let storyName: String
    let storyDescription: String
    let storyImageName: String
    let baseBalance: Int
    
    var availableCoinToGain: Int {
        return baseBalance * 10
    }
}

extension StoryEntity {
    static func mock() -> [Self] {
        return [
            .init(
                storyId: "story-mock-01",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                baseBalance: 1
            ),
            .init(
                storyId: "story-mock-02",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                baseBalance: 5
            ),
            .init(
                storyId: "story-mock-03",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                baseBalance: 10
            )
        ]
    }
}
