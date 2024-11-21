//
//  PracticeHomeView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import SwiftUI

struct PracticeHomeView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    @StateObject private var viewModel: LevelListViewModel = .init()
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    Text("Latihan")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cWhite))
                    Text("Pilih bacaan yang kamu suka dan mulai melatih pemahaman membacamu!")
                        .font(.callout)
                        .foregroundStyle(Color(.cWhite))
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                VStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color(.cWhite))
                        .font(.title)
                        .fontWeight(.bold)
                        .onTapGesture {
                            appRouter.push(.searchLevel)
                        }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 32) {
                    if viewModel.levels.isEmpty == false {
                        ForEach(viewModel.levels, id: \.id) { level in
                            CerdikiawanLevelSelectionContainer(level: level)
                        }
                    }
                    else {
                        Text("No Level Data")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    
                }
                .safeAreaPadding(.horizontal, 16)
                .safeAreaPadding(.vertical, 32)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.cGray))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16
                )
            )
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
        }
        .background(Color(.cDarkBlue))
        .onAppear() {
            viewModel.setup()
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                PracticeHomeView()
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
