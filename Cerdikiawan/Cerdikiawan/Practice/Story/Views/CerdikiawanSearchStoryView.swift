//
//  CerdikiawanSearchLevelView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 27/11/24.
//

import SwiftUI

struct CerdikiawanSearchStoryView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    @StateObject var viewModel: SearchStoryViewModel
    
    init() {
        _viewModel = .init(
            wrappedValue: .init(
                storyRepository: SupabaseStoryRepository.shared
            )
        )
    }
    
    var body: some View {
        VStack {
            CerdikiawanSearchField(placeholder: "Cari", text: $viewModel.searchText)
                .padding()
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            }
            else if viewModel.searchResult.isEmpty {
                Spacer()
                Text("Bacaan tidak ditemukan")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                Spacer()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hasil Pencarian")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.searchResult, id: \.storyId) { value in
                                CerdikiawanLevelSelectionCard(
                                    imageName: value.storyImageName,
                                    title: value.storyName,
                                    description: value.storyDescription,
                                    availableBalanceToGain: value.availableCoinToGain,
                                    onTapGesture: {
                                        appRouter.push(.practice(story: value))
                                    }
                                )
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchAllStories()
            }
        }
        .onChange(of: viewModel.searchText) { _, value in
            Task {
                try await viewModel.searchStory()
            }
        }
        .navigationTitle("Cari bacaan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(
                    action: {
                        appRouter.popToRoot()
                    },
                    label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17))
                            .foregroundStyle(Color(.cDarkBlue))
                    }
                )
            })
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanSearchStoryView()
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
            .padding(.horizontal, 16)
        }
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
