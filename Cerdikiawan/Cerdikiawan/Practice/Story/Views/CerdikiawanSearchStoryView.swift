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
    
    init(
        storyList: [StoryEntity]
    ) {
        _viewModel = .init(
            wrappedValue: .init(
                storyList: storyList
            )
        )
    }
    
    var body: some View {
        VStack {
            CerdikiawanSearchField(placeholder: "Cari", text: $viewModel.searchText)
                .padding(.horizontal, 4)
                .padding(.vertical, 16)
            
            if viewModel.storyList.isEmpty {
                Text("Bacaan tidak ditemukan")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
                    .frame(maxHeight: .infinity, alignment: .center)
            }
            else {
                VStack(alignment: .leading, spacing: 8) {
                    if viewModel.searchResult.isEmpty && viewModel.searchText.isEmpty == false {
                        Text("Bacaan tidak ditemukan")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.gray)
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                    else {
                        Text("Hasil Pencarian")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                if viewModel.searchText.isEmpty {
                                    ForEach(viewModel.storyList, id: \.storyId) { value in
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
                                else {
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
                        .scrollIndicators(.never)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: viewModel.searchText) { _, value in
            viewModel.filterStory()
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
                CerdikiawanSearchStoryView(
                    storyList: StoryEntity.mock()
                )
                .padding(.horizontal, 16)
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
    }
    .environmentObject(appRouter)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
}
