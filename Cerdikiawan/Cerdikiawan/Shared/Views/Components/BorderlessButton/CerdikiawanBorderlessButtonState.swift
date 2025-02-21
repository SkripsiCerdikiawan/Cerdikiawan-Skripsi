//
//  CerdikiawanBorderlessButtonState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 12/11/24.
//

import SwiftUI

enum CerdikiawanBorderlessButtonState {
    case enabled
    case disabled
    
    var textColor: Color {
        switch self {
        case .enabled:
            return Color(.cDarkBlue)
        case .disabled:
            return Color(.secondaryLabel)
        }
    }
}
