//
//  CerdikiawanMultipleChoiceViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation

class CerdikiawanMultipleChoiceViewModel: ObservableObject {
    var data: MultipleChoiceEntity
    @Published var state: CerdikiawanMultipleChoiceContainerState
    @Published var selectedAnswerID: String
    
    init(data: MultipleChoiceEntity){
        self.data = data
        self.state = .answering
        self.selectedAnswerID = ""
    }
    
    func handleChoiceSelection(answer: MultipleChoiceAnswerEntity) {
        self.selectedAnswerID = answer.id
    }
}
