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
        // TODO: Play Voice Over here
        if self.activeVoiceOverID == paragraph.id {
            self.activeVoiceOverID = ""
        }
        else {
            self.activeVoiceOverID = paragraph.id
        }
    }
}
