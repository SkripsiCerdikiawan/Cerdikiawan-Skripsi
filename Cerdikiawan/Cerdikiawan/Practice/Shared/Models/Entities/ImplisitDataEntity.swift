//
//  ImplisitDataEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 23/11/24.
//

struct ImplisitDataEntity {
    var implisitCount: Int = 0
    var implisitCorrect: Int = 0
    
    var percentage: Int {
        guard implisitCount > 0 else { return -1 }
        return Int(Double(implisitCorrect) / Double(implisitCount) * 100.0)
    }
}
