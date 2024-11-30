//
//  CerdikiawanPageViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanPageViewModel: ObservableObject {
    @Published var data: PageEntity
    @Published var activeVoiceOverID: String = ""
    
    init(page: PageEntity) {
        self.data = page
    }
    
    func handleVoiceOverTap(paragraph: ParagraphEntity) {
        // MARK: Change property sound effect here if applicable
        if self.activeVoiceOverID == paragraph.id {
            self.activeVoiceOverID = ""
            VoiceOverHelper.shared.stopVoiceOver()
        }
        else {
            VoiceOverHelper.shared.stopVoiceOver()
            self.activeVoiceOverID = paragraph.id
            VoiceOverHelper.shared.playVoiceOver(paragraph.paragraphText)
        }
    }
    
    func determineState(paragraph: ParagraphEntity) -> CerdikiawanVoiceOverButtonType {
        return self.activeVoiceOverID == paragraph.id ? .disabled : .enabled
    }
}
