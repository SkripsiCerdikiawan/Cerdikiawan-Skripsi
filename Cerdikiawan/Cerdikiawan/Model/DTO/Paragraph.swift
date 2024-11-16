//
//  Paragraph.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabaseParagraph: Codable {
    let ParagraphID: UUID
    let PageID: UUID
    let ParagraphText: String
    let ParagraphSoundPath: String
}
