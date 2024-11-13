//
//  CerdikiawanWordMatchTextContainerState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanWordMatchTextContainerState {
    case question
    case blank
    case filled
    case correct
    case incorrect
    case disabled
    
    var borderRadius: CGFloat {
        return 8
    }
    
    var borderWidth: CGFloat {
        return 0.5
    }
    
    var backgroundColor: Color {
        switch self {
        case .question:
            return Color(.cWhite)
        case .blank:
            return Color(.cWhite)
        case .filled:
            return Color(.cOrange)
        case .correct:
            return Color(.cLightBlue)
        case .incorrect:
            return Color(.cRed)
        case .disabled:
            return Color(.systemFill)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .question:
            return Color.clear
        case .blank:
            return Color(.cDarkOrange)
        case .filled:
            return Color(.cDarkOrange)
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        case .disabled:
            return Color(.secondaryLabel)
        }
    }
    
    var textColor: Color {
        switch self {
        case .question:
            return Color(.cBlack)
        case .blank:
            return Color(.cWhite)
        case .filled:
            return Color(.cBlack)
        case .correct:
            return Color(.cDarkBlue)
        case .incorrect:
            return Color(.cDarkRed)
        case .disabled:
            return Color(.secondaryLabel)
        }
    }
    
    var font: Font {
        return .callout
    }
    
    var fontWeight: Font.Weight {
        switch self {
        case .question:
            return .regular
        case .blank:
            return .regular
        default:
            return .medium
        }
    }
}
