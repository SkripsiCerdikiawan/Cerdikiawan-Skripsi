//
//  CerdikiawanWordMatchTextContainerType.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

enum CerdikiawanWordMatchTextContainerType {
    case question
    case answer
    case blank
    case filled
    case correct
    case incorrect
    case disabled
    
    var borderRadius: CGFloat {
        return 8
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .blank:
            return 2
        default:
            return 0.5
        }
    }
    
    func backgroundColor(isPressed: Bool) -> Color {
        switch self {
        case .question:
            return Color(.cWhite)
        case .answer:
            return isPressed ? Color(.cDarkOrange) : Color(.cWhite)
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
        case .answer:
            return Color(.cDarkOrange)
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
    
    func textColor(isPressed: Bool) -> Color {
        switch self {
        case .question:
            return Color(.cBlack)
        case .answer:
            return isPressed ? Color(.cWhite) : Color(.cDarkOrange)
        case .blank:
            return Color(.cDarkOrange)
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
    
    var scaleEffect: CGFloat {
        switch self {
        case .answer:
            return 0.9
        case .filled:
            return 0.9
        default:
            return 1

        }
    }
    
    func textConfiguration(label: String) -> String{
        if label.isEmpty {
            return "?"
        }
        return label
    }
}
