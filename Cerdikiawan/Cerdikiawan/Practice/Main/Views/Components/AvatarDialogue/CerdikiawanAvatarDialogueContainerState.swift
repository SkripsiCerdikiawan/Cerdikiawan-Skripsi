//
//  CerdikiawanAvatarDialogueContainerState.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

enum CerdikiawanAvatarDialogueContainerState {
    case normal
    case checkAnswer
    case correct
    case incorrect
    
    var buttonType: CerdikiawanButtonType {
        switch self {
        case .normal:
            return .disabled
        case .checkAnswer:
            return .secondary
        case .correct:
            return .primary
        case .incorrect:
            return .primary
        }
    }
    
    var buttonLabel: String {
        switch self {
        case .normal:
            "Cek Jawaban"
        case .checkAnswer:
            "Cek Jawaban"
        case .correct:
            "Lanjutkan"
        case .incorrect:
            "Lanjutkan"
        }
    }
    
    var avatarState: CerdikiawanAvatarState {
        switch self {
        case .normal:
            return .normal
        case .checkAnswer:
            return .normal
        case .correct:
            return .happy
        case .incorrect:
            return .sad
        }
    }
}
