//
//  Paragraph.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseParagraph: Codable {
    let paragraphId: UUID
    let pageId: UUID
    let paragraphText: String
    let paragraphSoundPath: String
    let paragraphOrder: Int
}
