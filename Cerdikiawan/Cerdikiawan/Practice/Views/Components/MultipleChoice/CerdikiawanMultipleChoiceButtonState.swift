//
//  CerdikiawanMultipleChoiceButtonState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanMultipleChoiceButtonState {
    case normal
    case selected
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
            return Color(.cWhite)
        case .selected:
            return Color(.cOrange)
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
        case .selected:
            return Color(.cDarkOrange)
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        }
    }
    
    var textColor: Color {
        switch self {
        case .normal:
            return Color(.cBlack)
        case .selected:
            return Color(.cBlack)
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        }
    }
    
    var icon: Image? {
        switch self {
        case .correct:
            return Image(systemName: "checkmark")
        case .incorrect:
            return Image(systemName: "xmark")
        default:
            return nil
        }
    }
    
    var font: Font {
        return .callout
    }
    
    var fontWeight: Font.Weight {
        switch self {
        case .normal:
            return .regular
        case .selected:
            return .medium
        case .correct:
            return .medium
        case .incorrect:
            return .medium
        }
    }
}
