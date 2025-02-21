//
//  CerdikiawanResultStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

enum CerdikiawanScoreStyle {
    case great
    case normal
    case low
    
    var foregroundPrimaryColor: Color {
        switch self {
        case .great:
            return Color(.cDarkBlue)
        case .normal:
            return Color(.cDarkOrange)
        case .low:
            return Color(.cDarkRed)
        }
    }
    
    var foregroundSecondaryColor: Color {
        switch self {
        case .great:
            return Color(.cLightBlue)
        case .normal:
            return Color(.cOrange)
        case .low:
            return Color(.cRed)
        }
    }
    
    static func determineStyle(value: Int) -> Self {
        switch value {
        case -1..<25:
            return .low
        case 25..<70:
            return .normal
        case 70..<101:
            return .great
        default:
            return .normal
        }
    }
}
