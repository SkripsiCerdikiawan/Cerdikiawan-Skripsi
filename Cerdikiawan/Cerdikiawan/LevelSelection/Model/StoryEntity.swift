//
//  LevelEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation

struct StoryEntity {
    let storyId: UUID
    let storyName: String
    let storyDescription: String
    let storyImageName: String
    let availableCoinToGain: Int
}

extension StoryEntity {
    static func mock() -> [Self] {
        return [
            .init(
                storyId: UUID(),
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                availableCoinToGain: 30
            ),
            .init(
                storyId: UUID(),
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                availableCoinToGain: 30
            ),
            .init(
                storyId: UUID(),
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                availableCoinToGain: 30
            )
        ]
    }
}
