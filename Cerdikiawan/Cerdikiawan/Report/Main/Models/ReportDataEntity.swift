//
//  ReportData.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

struct ReportDataEntity {
    var kosakataPercentage: Int
    var idePokokPercentage: Int
    var implisitPercentage: Int
    
    var summaryPercentage: Int {
        let result = (kosakataPercentage + idePokokPercentage + implisitPercentage) / 3
        return Int(result)
    }
    
    var summary: String {
        switch summaryPercentage {
        case -1..<25:
            return "Kurang"
        case 25..<50:
            return "Cukup"
        case 50..<85:
            return "Baik"
        case 85..<101:
            return "Sangat Baik"
        default:
            return "ERROR"
        }
    }
}

extension ReportDataEntity {
    static func mock() -> [ReportDataEntity] {
        return [
            .init(
                kosakataPercentage: 100,
                idePokokPercentage: 100,
                implisitPercentage: 100
            ),
            .init(
                kosakataPercentage: 100,
                idePokokPercentage: 50,
                implisitPercentage: 75
            ),
            .init(
                kosakataPercentage: 45,
                idePokokPercentage: 50,
                implisitPercentage: 75
            ),
            .init(
                kosakataPercentage: 20,
                idePokokPercentage: 10,
                implisitPercentage: 30
            )
        ]
    }
}
