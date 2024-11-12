//
//  CerdikiawanTextFieldState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

enum CerdikiawanTextFieldState {
    case enabled
    case disabled
    
    var backgroundColor: Color {
        switch self {
        case .enabled:
            return Color(.cWhite)
        case .disabled:
            return Color(.systemFill)
        }
    }
    
    var textColor: Color {
        switch self {
        case .enabled:
            return Color(.cBlack)
        case .disabled:
            return Color(.label)
        }
    }
}
