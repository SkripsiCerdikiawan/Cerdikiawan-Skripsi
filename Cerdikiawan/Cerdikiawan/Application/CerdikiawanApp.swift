//
//  CerdikiawanApp.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 29/09/24.
//

import SwiftUI

@main
struct CerdikiawanApp: App {
    @StateObject var appRouter: AppRouter = .init()
    @StateObject var sessionData: SessionData = .init()
    
    var body: some Scene {
        WindowGroup {
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
            })
            .onAppear() {
                appRouter.startScreen = .login
            }
            .environmentObject(appRouter)
            .environmentObject(sessionData)
        }
    }
}
