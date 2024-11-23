//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class StoryViewModel: ObservableObject {
    let QUESTION_LIMIT = 10 // Constant to fetch how many question in a story
    
    let story: StoryEntity
    
    @Published var practiceList: [PracticeEntity] = []
    
    @Published var kosakataCorrect: Int = 0
    @Published var idePokokCorrect: Int = 0
    @Published var implisitCorrect: Int = 0
    
    init(story: StoryEntity) {
        self.story = story
    }
    
    func setup(
        userID: String
    ) {
        if let question = fetchQuestionForPractice(userID: userID) {
            practiceList.append(question)
        }
    }
    
    // TODO: Replace with Repo
    func fetchQuestionForPractice(userID: String) -> PracticeEntity? {
        return PracticeEntity.mock()[practiceList.count]
    }
    
    // MARK: - Business Logic
    func handleNextQuestion(userID: String) {
        // Temp logic
        if let question = fetchQuestionForPractice(userID: userID) {
            practiceList.append(question)
        }
    }
}
