//
//  CerdikiawanCharacterContainerState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanCharacterContainerState {
    case normal
    case correct
    case incorrect
    
    var borderRadius: CGFloat {
        return 8
    }
    
    var borderWidth: CGFloat {
        return 0.5
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal:
            return Color(.systemGray5)
        case .correct:
            return Color(.cLightBlue)
        case .incorrect:
            return Color(.cRed)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .normal:
            return Color(.gray)
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        }
    }
    
    var textColor: Color {
        return Color(.cBlack)
    }
    
    var font: Font {
        return .callout
    }
    
    var fontWeight: Font.Weight {
        return .medium
    }
    
    var iconColor: Color {
        switch self {
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        default:
            return .clear
        }
    }
    
    var icon: Image? {
        switch self {
        case .normal:
            return nil
        case .correct:
            return Image(systemName: "checkmark")
        case .incorrect:
            return Image(systemName: "xmark")
        }
    }
}
