//
//  CerdikiawanReadingTypeRowCardStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

enum CerdikiawanReadingTypeRowCardStyle {
    case top
    case middle
    case bottom
    
    var cornerConfiguration: UnevenRoundedRectangle {
        switch self {
        case .top:
            return UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16)
        case .middle:
            return UnevenRoundedRectangle()
        case .bottom:
            return UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
        }
    }
    
    var backgroundColor: Color {
        return Color(.cWhite)
    }
}
