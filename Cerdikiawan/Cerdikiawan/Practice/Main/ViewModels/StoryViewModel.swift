//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation
import SwiftUI

class StoryViewModel: ObservableObject {
    // User Data
    @Published var userID: String?
    @Published var userCharacter: CharacterEntity?
    
    let story: StoryEntity
    @Published var currentPageIdx: Int = 0
    @Published var correctCount: Int = 0
    
    @Published var questionList: [PracticeEntity] = [] // Index and Content (For ensuring the view re-render on update)
    @Published var activeQuestion: PracticeEntity?
    
    @Published var kosakata: KosakataDataEntity = .init()
    @Published var idePokok: IdePokokDataEntity = .init()
    @Published var implisit: ImplisitDataEntity = .init()
    
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
        self.questionList = fetchQuestionForPractice(userID: userID, storyID: story.storyId)
        self.activeQuestion = questionList.first
    }
    
    // TODO: Replace with Repo
    func fetchQuestionForPractice(userID: String, storyID: String) -> [PracticeEntity] {
        return PracticeEntity.mock()
    }
    
    // TODO: Replace With Repo
    func fetchUserCharacter(userID: String) -> CharacterEntity {
        return CharacterEntity.mock()[1]
    }
    
    // MARK: - Business Logic
    
    // Handle next after answering question
    func handleNext(isCorrect: Bool, appRouter: AppRouter) {
        if isCorrect == true {
            correctCount += 1 // Add Correct Count
        }
        debugPrint("User Answer is Correct: \(isCorrect)")
        
        // Save Reading Comprehension Data
        updateReadingComprehension(isCorrect: isCorrect)
        
        // Check if already end of page
        guard currentPageIdx < questionList.count else {
            debugPrint("All Question answered")
            handleDisplayResultData(appRouter: appRouter)
            return
        }
        
        // Display next page if not end of page
        displayNextPage()
    }
    
    func updateReadingComprehension(isCorrect: Bool) {
        // Calculate Tipe Pemahaman Membaca Data
        guard let activeQuestion = self.activeQuestion else {
            debugPrint("Error! No Active Question Data Detected!")
            return
        }
        
        switch activeQuestion.question.type {
        case .idePokok:
            if isCorrect {
                self.idePokok.idePokokCorrect += 1
            }
            self.idePokok.idePokokCount += 1
        case .implisit:
            if isCorrect {
                self.implisit.implisitCorrect += 1
            }
            self.implisit.implisitCount += 1
        case .kosakata:
            if isCorrect {
                self.kosakata.kosakataCorrect += 1
            }
            self.kosakata.kosakataCount += 1
        }
    }
    
    // Function to display next page to the user
    func displayNextPage() {
        self.activeQuestion = questionList[currentPageIdx]
       
    }
    
    // Function that will be called after the user complete the story (Save Progress Data to user, etc)
    func handleDisplayResultData(appRouter: AppRouter) {
        let resultData = createResultData()
      
        debugPrint("Kosakata: \(self.kosakata.percentage)")
        debugPrint("Implisit: \(self.implisit.percentage)")
        debugPrint("Ide Pokok: \(self.idePokok.percentage)")
        
        appRouter.push(.storyCompletion(
            result: resultData,
            character: userCharacter ?? .mock()[0],
            onCompletion: {
                debugPrint("Complete!")
            }
        ))
    }
    
    // Function to create result data entity
    func createResultData() -> ResultDataEntity {
        let correctCount = self.correctCount
        let incorrectCount = self.questionList.count - correctCount
        let totalQuestions = self.questionList.count
        
        return .init(
            correctCount: correctCount,
            inCorrectCount: incorrectCount,
            totalQuestions: totalQuestions,
            baseBalance: self.story.baseBalance
        )
    }
    
}
