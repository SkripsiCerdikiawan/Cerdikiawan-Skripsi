//
//  CerdikiawanButtonStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

enum CerdikiawanButtonType {
    case primary
    case secondary
    case destructive
    case disabled
    
    var labelColor: Color {
        switch self {
        case .disabled:
            return Color(.secondaryLabel)
        default:
            return Color(.cWhite)
        }
    }
    
    var fillColor: Color {
        switch self {
        case .primary:
            return Color(.cDarkBlue)
        case .secondary:
            return Color(.cOrange)
        case .destructive:
            return Color(.cDarkRed)
        case .disabled:
            return Color(.systemFill)
        }
    }
    
    var scaleEffect: CGFloat {
        switch self {
        case .disabled:
            return 1
        default:
            return 0.9
        }
    }
}
