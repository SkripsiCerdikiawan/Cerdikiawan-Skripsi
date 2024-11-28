//
//  KosakataDataEntity.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 23/11/24.
//

struct KosakataDataEntity {
    var kosakataCount: Int = 0
    var kosakataCorrect: Int = 0
    
    var percentage: Int {
        guard kosakataCount > 0 else { return 100 }
        return Int(Double(kosakataCorrect) / Double(kosakataCount) * 100.0)
    }
}
