//
//  ContentView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 29/09/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            CerdikiawanButton(
                label: "Test Navigate",
                action: {
                    appRouter.push(.searchLevel)
                }
            )
        }
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    
    NavigationStack(path: $appRouter.path, root: {
        if let startScreen = appRouter.startScreen {
            appRouter.build(startScreen)
                .navigationDestination(for: Screen.self, destination: { screen in
                    appRouter.build(screen)
                })
                .sheet(item: $appRouter.sheet, content: { sheet in
                    appRouter.build(sheet)
                })
        }
        else {
            Text("Not Routed Anywhere!")
        }
    })
    .onAppear() {
        appRouter.startScreen = .home
    }
    .environmentObject(appRouter)
    
}
