import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoryViewModel()
    
    var body: some View {
        VStack {
//            if viewModel.isLoading {
//                ProgressView("Loading...")
//            } else {
//                List(viewModel.stories, id: \.self) { story in
//                    Text(story.title) // Customize with your story properties
//                }
//            }
        }
        .onAppear {
            Task {
                await viewModel.loadStories()
            }
        }
    }
}
