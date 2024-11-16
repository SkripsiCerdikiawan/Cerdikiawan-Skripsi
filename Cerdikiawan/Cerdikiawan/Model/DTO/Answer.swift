//
//  Answer.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

protocol SupabaseAnswer: Codable {
    var answerId: UUID { get }
    var questionId: UUID { get }
}
