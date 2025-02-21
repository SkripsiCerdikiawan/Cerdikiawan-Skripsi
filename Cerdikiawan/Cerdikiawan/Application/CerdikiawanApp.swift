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
    @StateObject var sessionData: SessionData
    
    init () {
        _sessionData = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared,
                profileRepository: SupabaseProfileRepository.shared
            )
        )
    }
    
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
            .onAppear {
                #if DEBUG
                appRouter.startScreen = .home
                sessionData.user = .mock()[0]
                #else
                Task {
                    if let user = try await sessionData.fetchLastUserSession() {
                        appRouter.startScreen = .home
                        sessionData.user = user
                    } else {
                        appRouter.startScreen = .login
                    }
                }
                #endif
            }
            .environmentObject(appRouter)
            .environmentObject(sessionData)
            .preferredColorScheme(.light)
        }
    }
}
