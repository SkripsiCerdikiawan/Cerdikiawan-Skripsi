//
//  ErrorHandler.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation

enum ErrorStatus: Error {
    case success
    case notFound
    case invalidInput
    case serverError
    case jsonError
}

enum JsonError: Error {
    case success
    case notFound
    case decodedFailed(Error)
    case encodedFailed(Error)
    case dataCorrupted
}
