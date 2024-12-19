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
    
    @Published var pageDisplayed: Bool = false
    #if DEBUG
    @Published var readingTimeSecond: Int = 0
    #else
    @Published var readingTimeSecond: Int = 5
    #endif
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
        self.pageDisplayed = true
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
