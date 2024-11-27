//
//  QuestionViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 23/11/24.
//

import Foundation

class QuestionViewModel: ObservableObject {
    let data: PracticeEntity
    let character: CharacterEntity
    
    @Published var passageDisplayed: Bool = false
    @Published var readingTimeSecond: Int = 0
    @Published var continueButtonDisabled: Bool = true
    
    init(
        data: PracticeEntity,
        character: CharacterEntity
    ){
        self.data = data
        self.character = character
    }
    
    // MARK: - Business Logic
    func handleDisplayQuestion() {
        self.passageDisplayed = true
    }
    
    func startReadingCountDown() {
        Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: readingTimeSecond > 0,
            block: { timer in
                if self.readingTimeSecond > 0 {
                    self.readingTimeSecond -= 1
                } else {
                    timer.invalidate()
                    self.continueButtonDisabled = false
                }
            })
    }
}
