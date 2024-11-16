//
//  StoryViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 14/11/24.
//


import Foundation

class StoryViewModel: ObservableObject {
    @Published var stories: [SupabaseStory] = []
    @Published var isLoading = false
    
    func loadStories() async {
        isLoading = true
        do {
            let fetchedStories = try await StoryRepository.init().fetchStories()
            DispatchQueue.main.async {
                self.stories = fetchedStories
                self.isLoading = false
            }
        } catch {
            print("Error fetching stories: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
