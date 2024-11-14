//
//  CerdikiawanResultStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

enum CerdikiawanResultStyle {
    case greatscore
    case normal
    case lowscore
    
    var foregroundPrimaryColor: Color {
        switch self {
        case .greatscore:
            return Color(.cDarkBlue)
        case .normal:
            return Color(.cDarkOrange)
        case .lowscore:
            return Color(.cDarkRed)
        }
    }
    
    var foregroundSecondaryColor: Color {
        switch self {
        case .greatscore:
            return Color(.cLightBlue)
        case .normal:
            return Color(.cOrange)
        case .lowscore:
            return Color(.cRed)
        }
    }
}
