//
//  CerdikiawanProgressBarStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import Foundation
import SwiftUI

enum CerdikiawanProgressBarStyle {
    case empty
    case filled
    case complete
    
    var height: CGFloat {
        return 12
    }
    
    var backgroundColor: Color {
        return Color(.systemGray4)
    }
    
    var barColor: Color {
        switch self {
        case .empty:
            return .clear
        case .filled:
            return Color(.cDarkOrange)
        case .complete:
            return Color(.cDarkBlue)
        }
    }
}
