//
//  Page.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 10/11/24.
//

import Foundation

struct SupabasePage: Codable {
    let pageId: UUID
    let storyId: UUID
    let pagePicturePath: String
    let pageOrder: Int
}
