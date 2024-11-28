//
//  ReportStoryEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 19/11/24.
//

import Foundation

struct ReportStoryEntity {
    let storyId: String
    let storyName: String
    let storyDescription: String
    let storyImageName: String
    let attemptStatus: Bool
}

extension ReportStoryEntity {
    static func mock() -> [ReportStoryEntity] {
        return [
            .init(
                storyId: "report-story-1",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                attemptStatus: true
            ),
            .init(
                storyId: "report-story-2",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                attemptStatus: false
            ),
            .init(
                storyId: "report-story-3",
                storyName: "Perjalanan Budi ke Pasar",
                storyDescription: "Budi sedang menceritakan pengalamannya di pasar kemarin. Kira - kira ada hal menarik apa ya?",
                storyImageName: "DEBUG_IMAGE",
                attemptStatus: true
            )
        ]
    }
}
