//
//  CerdikiawanReportLevelCardStyle.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

enum CerdikiawanReportLevelCardStyle {
    case havePlay
    case neverPlay
    
    var foregroundColor: Color {
        switch self {
        case .havePlay:
            return Color(.cDarkBlue)
        case .neverPlay:
            return Color(.cDarkOrange)
        }
    }
    
    var displayedText: String {
        switch self {
        case .havePlay:
            return "Dimainkan"
        case .neverPlay:
            return "Belum dimainkan"
        }
    }
}
