//
//  CerdikiawanReportDetailViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import Foundation

class CerdikiawanReportDetailViewModel: ObservableObject {
    @Published var story: ReportStoryEntity
    @Published var currentlyPlayedAttemptId: String?
    
    init(story: ReportStoryEntity) {
        self.story = story
    }
    
    public func fetchAttempts() -> [AttemptDataEntity] {
        return AttemptDataEntity.mock()
    }
    
    public func playRecordSound() {
        //TODO: Fetch and play recroding sound here
    }
}
