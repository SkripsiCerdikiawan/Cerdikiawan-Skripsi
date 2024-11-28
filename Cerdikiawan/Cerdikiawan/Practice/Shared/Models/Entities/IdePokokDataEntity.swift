//
//  IdePokokDataEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 23/11/24.
//

struct IdePokokDataEntity {
    var idePokokCount: Int = 0
    var idePokokCorrect: Int = 0
    
    var percentage: Int {
        guard idePokokCount > 0 else { return 100 }
        return Int(Double(idePokokCorrect) / Double(idePokokCount) * 100.0)
    }
}
