//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation
import SwiftUI

class PracticeViewModel: ObservableObject {
    // User Data
    @Published var userID: String?
    @Published var userCharacter: CharacterEntity?
    
    let story: StoryEntity
    @Published var currentPageIdx: Int = 0
    @Published var correctCount: Int = 0
    @Published var questionAnsweredFlag: Bool = false
    @Published var isLoading = false
    
    @Published var practiceList: [PracticeEntity] = [] // Index and Content (For ensuring the view re-render on update)
    @Published var activePractice: PracticeEntity?
    
    @Published var kosakata: KosakataDataEntity = .init()
    @Published var idePokok: IdePokokDataEntity = .init()
    @Published var implisit: ImplisitDataEntity = .init()
    
    @Published var appRouter: AppRouter?
    
    private var finishButtonPressedStatus: Bool = false
    
    private var ownedCharacterRepository: ProfileOwnedCharacterRepository
    private var characterRepository: CharacterRepository
    private var pageRepository: PageRepository
    private var paragraphRepository: ParagraphRepository
    private var questionRepository: QuestionRepository
    private var wordBlankAnswerRepository: AnswerRepository
    private var wordMatchAnswerRepository: AnswerRepository
    private var multipleChoiceAnswerRepository: AnswerRepository
    
    init(
        story: StoryEntity,
        ownedCharacterRepository: ProfileOwnedCharacterRepository,
        characterRepository: CharacterRepository,
        pageRepository: PageRepository,
        paragraphRepository: ParagraphRepository,
        questionRepository: QuestionRepository,
        wordBlankAnswerRepository: AnswerRepository,
        wordMatchAnswerRepository: AnswerRepository,
        multipleChoiceAnswerRepository: AnswerRepository
    ) {
        self.story = story
        self.ownedCharacterRepository = ownedCharacterRepository
        self.characterRepository = characterRepository
        self.pageRepository = pageRepository
        self.paragraphRepository = paragraphRepository
        self.questionRepository = questionRepository
        self.wordBlankAnswerRepository = wordBlankAnswerRepository
        self.wordMatchAnswerRepository = wordMatchAnswerRepository
        self.multipleChoiceAnswerRepository = multipleChoiceAnswerRepository
    }
    
    @MainActor
    func setup(
        userID: String,
        appRouter: AppRouter
    ) async throws {
        self.userID = userID
        self.userCharacter = try await fetchUserCharacter(userID: userID)
        self.practiceList = try await fetchQuestionForPractice(userID: userID, storyID: story.storyId)
        self.activePractice = practiceList.first
        self.appRouter = appRouter
    }
    
    @MainActor
    func fetchQuestionForPractice(userID: String, storyID: String) async throws -> [PracticeEntity] {
        isLoading = true
        var practiceEntities: [PracticeEntity] = []
        
        // fetch page
        let pageRequest = PageRequest(storyId: UUID(uuidString: storyID))
        let (pages, pageStatus) = try await pageRepository.fetchPagesById(request: pageRequest)
        
        guard pageStatus == .success, pages.isEmpty == false else {
            debugPrint("Page did not get fetched")
            isLoading = false
            return []
        }
        
        let sortedPages = pages.sorted { $0.pageOrder < $1.pageOrder }
        
        for page in sortedPages {
            //fetch paragraph
            let paragraphRequest = ParagraphRequest(pageId: page.pageId)
            let (paragraphs, paragraphStatus) = try await paragraphRepository.fetchParagraphsById(request: paragraphRequest)
            
            guard paragraphStatus == .success else {
                debugPrint("Paragraph did not get fetched")
                isLoading = false
                return []
            }
            
            var paragraphEntities: [ParagraphEntity] = []
            let sortedParagraph = paragraphs.sorted { $0.paragraphOrder < $1.paragraphOrder }
            
            for paragraph in sortedParagraph {
                let paragraphEntity = ParagraphEntity(id: paragraph.paragraphId.uuidString,
                                                      paragraphText: paragraph.paragraphText,
                                                      paragraphSoundPath: paragraph.paragraphSoundPath
                )
                paragraphEntities.append(paragraphEntity)
            }
            
            // create page entity
            let pageEntity = PageEntity(storyImage: page.pagePicturePath,
                                        paragraph: paragraphEntities
            )
            
            // fetch question
            let questionRequest = QuestionRequest(pageId: page.pageId)
            let (questions, questionStatus) = try await questionRepository.fetchQuestionsById(request: questionRequest)
            
            guard questionStatus == .success, let randomizedQuestion = questions.randomElement() else {
                debugPrint("Question did not get fetched")
                isLoading = false
                return []
            }
            
            let questionEntity: QuestionProtocol?
            
            if randomizedQuestion.questionType == "WordBlank" {
                // fetch word blank answer
                let wordBlankAnswerRequest = AnswerRequest(questionId: randomizedQuestion.questionId)
                let (answer, wordBlankStatus): ([SupabaseWordBlankAnswer], ErrorStatus) = try await wordBlankAnswerRepository.fetchAnswersById(request: wordBlankAnswerRequest)
                
                guard wordBlankStatus == .success, let wordBlankAnswer = answer.first else {
                    debugPrint("Word blank answer cannot be fetched")
                    isLoading = false
                    return []
                }
                
                questionEntity = WordBlankEntity(id: randomizedQuestion.questionId.uuidString,
                                                 question: randomizedQuestion.questionContent,
                                                 correctAnswerWord: wordBlankAnswer.answerContent,
                                                 letters: setWordBlankAnswer(answer: wordBlankAnswer.answerContent),
                                                 category: determineQuestionCategory(type: randomizedQuestion.questionCategory),
                                                 feedback: FeedbackEntity(correctFeedback: randomizedQuestion.questionFeedbackIfTrue,
                                                                          incorrectFeedback: randomizedQuestion.questionFeedbackIfFalse
                                                                         )
                )
                
            } else if randomizedQuestion.questionType == "WordMatch" {
                let wordMatchAnswerRequest = AnswerRequest(questionId: randomizedQuestion.questionId)
                let (answer, wordMatchStatus): ([SupabaseWordMatchAnswer], ErrorStatus) = try await wordMatchAnswerRepository.fetchAnswersById(request: wordMatchAnswerRequest)
                
                guard wordMatchStatus == .success, answer.isEmpty == false else {
                    debugPrint("Word match answer cannot be fetched")
                    debugPrint(answer)
                    isLoading = false
                    return []
                }
                
                let (questionPromptEntity, answerPromptEntity, pairValue) = setWordMatchQuestion(answers: answer)
                
                questionEntity = WordMatchEntity(id: randomizedQuestion.questionId.uuidString,
                                                 prompt: randomizedQuestion.questionContent,
                                                 questions: questionPromptEntity,
                                                 answers: answerPromptEntity,
                                                 pair: pairValue,
                                                 category: determineQuestionCategory(type: randomizedQuestion.questionCategory),
                                                 feedback: FeedbackEntity(correctFeedback: randomizedQuestion.questionFeedbackIfTrue,
                                                                          incorrectFeedback: randomizedQuestion.questionFeedbackIfFalse
                                                                         )
                )
                
            } else if randomizedQuestion.questionType == "MultiChoice" {
                let multiChoiceAnswerRequest = AnswerRequest(questionId: randomizedQuestion.questionId)
                
                let (answer, wordMatchStatus): ([SupabaseMultiChoiceAnswer], ErrorStatus) = try await multipleChoiceAnswerRepository.fetchAnswersById(request: multiChoiceAnswerRequest)
                
                guard wordMatchStatus == .success, answer.isEmpty == false else {
                    debugPrint("Word match answer cannot be fetched")
                    isLoading = false
                    return []
                }
                
                questionEntity = MultipleChoiceEntity(id: randomizedQuestion.questionId.uuidString,
                                                      question: randomizedQuestion.questionContent,
                                                      answer: setMultiChoiceAnswer(answers: answer),
                                                      correctAnswerID: answer.first(where: { $0.answerStatus == true })?.answerId.uuidString ?? "",
                                                      category: determineQuestionCategory(type: randomizedQuestion.questionCategory),
                                                      feedback: FeedbackEntity(correctFeedback: randomizedQuestion.questionFeedbackIfTrue,
                                                                               incorrectFeedback: randomizedQuestion.questionFeedbackIfFalse
                                                                              )
                )
                
            } else {
                debugPrint("Question type is not supported: \(randomizedQuestion)")
                isLoading = false
                return []
            }
            
            guard let chosenQuestion = questionEntity else {
                debugPrint("Question entity should not be nil")
                isLoading = false
                return []
            }
            
            let practiceEntity = PracticeEntity(id: UUID().uuidString,
                                                page: pageEntity,
                                                question: chosenQuestion
            )
            
            practiceEntities.append(practiceEntity)
        }
        
        debugPrint(practiceEntities)
        isLoading = false
        return practiceEntities
    }
    
    private func setMultiChoiceAnswer(answers: [SupabaseMultiChoiceAnswer]) -> [MultipleChoiceAnswerEntity] {
        var results: [MultipleChoiceAnswerEntity] = []
        
        for answer in answers {
            let entity = MultipleChoiceAnswerEntity(id: answer.answerId.uuidString, content: answer.answerContent)
            results.append(entity)
        }
        return results.shuffled()
    }
    
    private func setWordMatchQuestion(answers: [SupabaseWordMatchAnswer]) -> ([WordMatchTextEntity], [WordMatchTextEntity], [String : String]) {
        var questionEntities: [WordMatchTextEntity] = []
        var answerEntities: [WordMatchTextEntity] = []
        var key: [String : String] = [:]
        
        for answer in answers {
            if let question = answer.questionPrompt {
                let questionEntity = WordMatchTextEntity(id: answer.answerId.uuidString, content: question)
                questionEntities.append(questionEntity)
            }
            let answerEntity = WordMatchTextEntity(id: answer.answerId.uuidString, content: answer.answerPrompt)
            
            answerEntities.append(answerEntity)
            
            if answer.questionPrompt != nil {
                key[answer.answerId.uuidString] = answer.answerId.uuidString
            }
        }
        
        return(questionEntities.shuffled(), answerEntities.shuffled(), key)
    }
    
    private func setWordBlankAnswer(answer: String) -> [WordBlankLetterEntity] {
        var results: [WordBlankLetterEntity] = []
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let answerUppercasedSet = Set(answer.uppercased())
        
        for letter in answer {
            let entity = WordBlankLetterEntity(id: UUID().uuidString, letter: letter.uppercased())
            results.append(entity)
        }
        
        let filteredAlphabet = alphabet.filter { !answerUppercasedSet.contains($0) }
        
        for _ in 0..<3 {
            let randomLetterEntity = WordBlankLetterEntity(id: UUID().uuidString, letter: String(filteredAlphabet.randomElement() ?? "A"))
            results.append(randomLetterEntity)
        }
        return results.shuffled()
    }
    
    private func determineQuestionCategory(type: String) -> QuestionCategory {
        if type == "Kosakata" {
            return .kosakata
        } else if type == "IdePokok" {
            return .idePokok
        } else if type == "Implisit" {
            return .implisit
        } else {
            return .idePokok // MARK: Discuss with hans
        }
    }
    
    @MainActor
    func fetchUserCharacter(userID: String) async throws -> CharacterEntity {
        
        // Fetch owned characters
        guard let userId = UUID(uuidString: userID) else {
            debugPrint("User ID is not valid")
            return CharacterEntity.mock()[0]
        }
        let ownedCharacterRequest = ProfileOwnedCharacterFetchRequest(profileId: userId)
        let (ownedCharacters, ownedCharacterStatus) = try await ownedCharacterRepository.fetchProfileOwnedCharacter(request: ownedCharacterRequest)
        
        guard ownedCharacterStatus == .success, ownedCharacters.isEmpty == false else {
            debugPrint("Failed to fetch user owned character")
            return CharacterEntity.mock()[0]
        }
        
        var supabaseCharacter: SupabaseProfileOwnedCharacter? = nil
        
        // Check whether chosen character exist
        if let equippedCharacter = ownedCharacters.first(where: { $0.isChosen == true }) {
            supabaseCharacter = equippedCharacter
        } else {
            guard let firstCharacter = ownedCharacters.first else {
                debugPrint("Cannot find character to equip")
                return CharacterEntity.mock()[0]
            }
            
            let changeStatusRequest = ProfileOwnedCharacterUpdateRequest(profileId: userId,
                                                                         characterId: firstCharacter.characterId,
                                                                         isChosen: true)
            let (_, changeStatus) =  try await ownedCharacterRepository.updateProfileOwnedCharacter(request: changeStatusRequest)
            
            guard changeStatus == .success else {
                debugPrint("Failed to change status of character")
                return CharacterEntity.mock()[0]
            }
            supabaseCharacter = firstCharacter
        }
        
        // Fetching character data
        guard let activeCharacter = supabaseCharacter else {
            debugPrint("active character did not exist")
            return CharacterEntity.mock()[0]
        }
        
        let characterRequest = CharacterRequest(characterId: activeCharacter.characterId)
        let (character, characterStatus) = try await characterRepository.fetchCharacterById(request: characterRequest)
        
        guard characterStatus == .success, let userChosenCharacter = character else {
            debugPrint("Failed to fetch user chosen character")
            return CharacterEntity.mock()[0]
        }
        
        let characterEntity = CharacterEntity(id: activeCharacter.characterId.uuidString,
                                              name: userChosenCharacter.characterName,
                                              imagePath: userChosenCharacter.characterImagePath,
                                              description: userChosenCharacter.characterDescription
        )
        return characterEntity
    }
    
    // MARK: - Business Logic
    
    // Handle next after answering question
    func handleNext(isCorrect: Bool? = nil) {
        if let isCorrect = isCorrect {
            if isCorrect == true {
                correctCount += 1 // Add Correct Count
            }
            debugPrint("User Answer is Correct: \(isCorrect)")
            
            // Save Reading Comprehension Data
            updateReadingComprehension(isCorrect: isCorrect)
        }
        
        // Display next page if not end of page
        displayNextPage()
    }
    
    func updateReadingComprehension(isCorrect: Bool) {
        // Calculate Tipe Pemahaman Membaca Data
        guard let practice = self.activePractice else {
            debugPrint("Error! No Active Question Data Detected!")
            return
        }
        
        switch practice.question.category {
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
        guard let appRouter = appRouter else {
            fatalError("Error! App Router hasn't been setup")
        }
        
        // Check if user already answered all question
        guard currentPageIdx < practiceList.count else {
            debugPrint("All Question answered")
            if currentPageIdx == practiceList.count {
                handleDisplayRecordPage()
            }
            else {
                if finishButtonPressedStatus == false {
                    finishButtonPressedStatus = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: { [weak self] in
                        self?.handleDisplayResultData(appRouter: appRouter)
                    })
                }
            }
            return
        }
        
        self.activePractice = practiceList[currentPageIdx]
        
    }
    
    // Function to dislay record view
    func handleDisplayRecordPage() {
        questionAnsweredFlag = true
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
                appRouter.popToRoot()
            }
        ))
    }
    
    // Function to create result data entity
    func createResultData() -> ResultDataEntity {
        let correctCount = self.correctCount
        let incorrectCount = self.practiceList.count - correctCount
        let totalQuestions = self.practiceList.count
        
        guard let recordData = VoiceRecordingHelper.shared.getRecordingData() else {
            debugPrint("Recording data not found")
            return .init(
                correctCount: correctCount,
                inCorrectCount: incorrectCount,
                totalQuestions: totalQuestions,
                baseBalance: self.story.baseBalance,
                storyId: story.storyId,
                kosakataPercentage: self.kosakata.percentage,
                idePokokPercentage: self.idePokok.percentage,
                implisitPercentage: self.implisit.percentage,
                recordSoundData: Data()
            )
        }
        
        debugPrint("Result found")
        return .init(
            correctCount: correctCount,
            inCorrectCount: incorrectCount,
            totalQuestions: totalQuestions,
            baseBalance: self.story.baseBalance,
            storyId: story.storyId,
            kosakataPercentage: self.kosakata.percentage,
            idePokokPercentage: self.idePokok.percentage,
            implisitPercentage: self.implisit.percentage,
            recordSoundData: recordData
        )
    }
    
}
