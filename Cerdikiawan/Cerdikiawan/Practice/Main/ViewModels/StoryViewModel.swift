//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation
import SwiftUI

class StoryViewModel: ObservableObject {
    var QUESTION_LIMIT = 0 // Constant to fetch how many question in a story
    
    // User Data
    var userID: String?
    var userCharacter: CharacterEntity?
    
    let story: StoryEntity
    
    @Published var practiceList: [PracticeEntity] = []
    
    @Published var kosakataCorrect: Int = 0
    @Published var idePokokCorrect: Int = 0
    @Published var implisitCorrect: Int = 0
    
    @Published var passageDisplayed: Bool = false
    @Published var resultDisplayed: Bool = false
    
    init(
        story: StoryEntity
    ) {
        self.story = story
    }
    
    func setup(
        userID: String
    ) {
        self.userID = userID
        self.userCharacter = fetchUserCharacter(userID: userID)
        
        if let question = fetchQuestionForPractice(userID: userID) {
            practiceList.append(question)
        }
    }
    
    // TODO: Replace with Repo
    func fetchQuestionForPractice(userID: String) -> PracticeEntity? {
        return PracticeEntity.mock()[practiceList.count]
    }
    
    // TODO: Replace With Repo
    func fetchUserCharacter(userID: String) -> CharacterEntity {
        return CharacterEntity.mock()[0]
    }
    
    // MARK: - Business Logic
    // Handle next after read the passage
    func handleNext() {
        guard self.passageDisplayed == true else {
            self.passageDisplayed = true
            return
        }
    }
    
    // Handle next after answering question
    func handleNext(result: Bool) {
        debugPrint("User Answer is Correct: \(result)")
        
        guard practiceList.count < QUESTION_LIMIT else {
            debugPrint("All Question answered")
            return
        }
        
        guard let userID = userID,
            let question = fetchQuestionForPractice(userID: userID) else {
            fatalError("UserID or Question is not found!")
        }
    }
    
    
}
