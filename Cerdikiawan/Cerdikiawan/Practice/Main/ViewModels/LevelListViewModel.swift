//
//  LevelListViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

class LevelListViewModel: ObservableObject {
    @Published var levels: [LevelEntity]
    
    init() {
        levels = []
    }
    
    func setup(){
        levels = setupLevel()
    }
    
    func setupLevel() -> [LevelEntity] {
        return LevelEntity.mock()
    }
}
