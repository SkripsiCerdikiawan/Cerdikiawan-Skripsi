//
//  CerdikiawanReportDataViewModels.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 22/11/24.
//

import Foundation

class ReportDataViewModel: ObservableObject {
    @Published var reportData: ReportDataEntity?
    @Published var levelList: [ReportLevelEntity] = []
    
    func setup() {
        reportData = fetchReportData()
        levelList = fetchLevelListData()
    }
    
    // TODO: Replace with repo
    func fetchReportData() -> ReportDataEntity {
        return ReportDataEntity.mock()[3]
    }
    
    // TODO: Replace with repo
    func fetchLevelListData() -> [ReportLevelEntity] {
        return ReportLevelEntity.mock()
    }
    
    // MARK: - Business Logic
    func determineSummaryStyle(value: Int) -> CerdikiawanScoreStyle {
        switch value {
        case -1..<25:
            return .low
        case 25..<50:
            return .normal
        case 50..<80:
            return .great
        case 80..<101:
            return .great
        default:
            return .low
        }
    }
}
