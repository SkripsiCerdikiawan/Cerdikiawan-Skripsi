//
//  ResultDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ResultDataViewModels: ObservableObject {
    let character: CharacterEntity
    @Published var resultEntity: ResultDataEntity
    
    init(
        character: CharacterEntity,
        resultEntity: ResultDataEntity
    ) {
        self.character = character
        self.resultEntity = resultEntity
    }
    
    // TODO: Replace with repo
    func saveAttemptData(userID: String) -> Bool {
        debugPrint("Saving user data...")
        return true
    }
}
