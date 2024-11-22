//
//  ContentView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 29/09/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    @State private var tabSelection: HomeTabSelection = .practice
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                CerdikiawanPracticeHomeView()
                    .tag(HomeTabSelection.practice)
                    .tabItem({
                        Label(title: {
                            Text("Latihan")
                        }, icon: {
                            Image(systemName: "book.pages")
                        })
                    })
                
                CerdikiawanShopView()
                    .tag(HomeTabSelection.avatar)
                    .tabItem({
                        Label(title: {
                            Text("Karakter")
                        }, icon: {
                            Image(systemName: "theatermask.and.paintbrush")
                        })
                    })
                
                CerdikiawanReportView()
                    .tag(HomeTabSelection.report)
                    .tabItem({
                        Label(title: {
                            Text("Laporan")
                        }, icon: {
                            Image(systemName: "scroll")
                        })
                    })
            }
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    @Previewable
    @StateObject var sessionData: SessionData = .init()
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                HomeView()
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
    }
    .environmentObject(appRouter)
    .environmentObject(sessionData)
    .sheet(item: $appRouter.sheet, content: { sheet in
        appRouter.build(sheet)
    })
    .onAppear() {
        sessionData.user = .mock()[0]
    }
    
}
