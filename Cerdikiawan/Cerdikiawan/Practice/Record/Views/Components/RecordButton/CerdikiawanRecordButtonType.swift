//
//  CerdikiawanRecordButtonState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import Foundation
import SwiftUI

enum CerdikiawanRecordButtonType {
    case normal
    case recording
    case pause
    case replay
    case rerecord
    
    var text: String {
        switch self {
        case .normal:
            return "Rekam"
        case .recording:
            return "Hentikan Rekaman"
        case .pause:
            return "Berhenti Mendengarkan"
        case .replay:
            return "Dengarkan Rekaman"
        case .rerecord:
            return "Rekam Ulang"
        }
    }
    
    var borderRadius: CGFloat {
        return 8
    }
    
    var foregroundStyle: Color {
        return Color(.cWhite)
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal:
            return Color(.cDarkBlue)
        case .recording:
            return Color(.cDarkRed)
        case .pause:
            return Color(.cDarkOrange)
        case .replay:
            return Color(.cLightBlue)
        case .rerecord:
            return Color(.cOrange)
        }
    }
    
    var imageName: String {
        switch self {
        case .normal:
            return "microphone.fill"
        case .recording:
            return "stop.fill"
        case .pause:
            return "pause.fill"
        case .replay:
            return "play.fill"
        case .rerecord:
            return "microphone.fill"
        }
    }
    
    var fontColor: Color {
        return Color(.secondaryLabel)
    }
    
    var scaleEffect: CGFloat {
        return 0.9
    }
}
