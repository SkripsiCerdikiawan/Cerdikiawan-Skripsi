//
//  Screen.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

enum Screen {
    case login
    case register
    case home
    case searchLevel
    case practice
    case storyCompletion
    case profile
    case reportDetail
    case buyConfirmation
}

extension Screen: Identifiable {
    var id: Self { return self }
}

extension Screen: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}

extension Screen: Equatable {
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login),
            (.register, .register),
            (.home, .home),
            (.searchLevel, .searchLevel),
            (.practice, .practice),
            (.storyCompletion, .storyCompletion),
            (.profile, .profile),
            (.reportDetail, .reportDetail),
            (.buyConfirmation, .buyConfirmation):
            return true
        default:
            return false
        }
    }
}

