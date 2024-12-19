//
//  QuestionEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

protocol QuestionProtocol {
    var id: String { get set }
    var category: QuestionCategory { get set }
    var feedback: FeedbackEntity { get set }
    
}
