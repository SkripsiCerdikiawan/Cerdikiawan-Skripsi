//
//  CerdikiawanVoiceOverButtonState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanVoiceOverButtonType {
    case disabled
    case enabled
    
    var foregroundColor: Color {
        switch self {
        default:
            return Color(.cWhite)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .disabled:
            return Color(.systemFill)
        case .enabled:
            return Color(.cDarkBlue)
        }
    }
    
    var scaleEffect: CGFloat {
        return 0.9
    }
}
