//
//  CerdikiawanRecordDialogue.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 27/11/24.
//

import Foundation

enum CerdikiawanRecordDialogueState {
    case start
    case recording
    case review
    case replay
    
    var message: String {
        switch self {
        case .start:
            return "Tekan tombol diatas untuk merekam isi dari cerita ini."
        case .recording:
            return "Tekan tombol diatas untuk berhenti merekam."
        case .review:
            return "Oke! Rekaman kamu sudah siap. Kamu bisa mendengarkan ulang, merekam lagi ataupun melanjutkan!"
        case .replay:
            return "Mendengarkan ulang rekaman..."
        }
    }
    
    var characterState: CerdikiawanCharacterState {
        switch self {
        case .start:
            return .normal
        case .recording:
            return .normal
        case .review:
            return .happy
        case .replay:
            return .happy
        }
    }
    
    var buttonState: CerdikiawanButtonType {
        switch self {
        case .start:
            return .disabled
        case .recording:
            return .disabled
        case .review:
            return .primary
        case .replay:
            return .disabled
        }
    }
}
