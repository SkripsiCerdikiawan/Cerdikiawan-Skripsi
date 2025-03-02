//
//  CerdikiawanLoginView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 22/11/24.
//

import SwiftUI

struct CerdikiawanLoginView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: CerdikiawanLoginViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared,
                profileRepository: SupabaseProfileRepository.shared
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 36) {
            Image("LOGIN_APP_LOGO")
                .resizable()
                .frame(width: 183, height: 90.75)
            
            VStack {
                Text("Selamat datang di Cerdikiawan")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.black))
                Text("Membantu melatih pemahaman membaca")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundStyle(Color(.gray))
            }
            
            VStack(spacing: 12) {
                CerdikiawanTextField(placeholder: "Email", text: $viewModel.emailText)
                VStack(alignment: .leading) {
                    CerdikiawanSecureField(placeholder: "Password", text: $viewModel.passwordText)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.cDarkRed))
                            .padding(.leading, 8)
                    }
                }
            }
            
            VStack(spacing: 24) {
                CerdikiawanButton(
                    type: .primary,
                    label: "Masuk",
                    action: {
                        viewModel.connectDBStatus = true
                        Task {
                            if let user = try await viewModel.login() {
                                sessionData.user = user
                                appRouter.startScreen = .home
                                appRouter.popToRoot()
                            }
                            else {
                                viewModel.connectDBStatus = false
                            }
                        }
                    }
                )
                
                HStack {
                    Text("Tidak Mempunyai akun?")
                    CerdikiawanBorderlessButton(text: "Daftar disini", onTapAction: {
                        appRouter.push(.register)
                    })
                }
            }
        }
        .onAppear {
            viewModel.emailText = ""
            viewModel.passwordText = ""
            viewModel.errorMessage = nil
        }
        .overlay(content: {
            // Show loading bar overlay when updating data
            // To make sure the user won't do any operation
            if viewModel.connectDBStatus {
                ZStack {
                    Color.gray.opacity(0.5)
                    ProgressView("Menghubungkan...")
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .ignoresSafeArea()
            }
        })
    }
}

#Preview {
    @Previewable
    @StateObject var appRouter: AppRouter = .init()
    @Previewable
    @StateObject var sessionData: SessionData = .init(
        authRepository: SupabaseAuthRepository.shared,
        profileRepository: SupabaseProfileRepository.shared
    )
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanLoginView()
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.vertical, 16)
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
