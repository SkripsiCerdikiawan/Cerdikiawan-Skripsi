//
//  CerdikiawanRegisterView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import SwiftUI

struct CerdikiawanRegisterView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: CerdikiawanRegisterViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared,
                profileRepository: SupabaseProfileRepository.shared
            )
        )
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading) {
                Text("Daftar akun Cerdikiawan")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.black))
                Text("Membantu melatih pemahaman membaca")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundStyle(Color(.gray))
            }
            .padding(.leading, 4)
            
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Data diri anak")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.gray))
                            .padding(.leading, 4)
                        CerdikiawanTextField(placeholder: "Nama Lengkap Anak", text: $viewModel.nameText)
                    }
                    CerdikiawanDatePickerField(placeholder: "Tanggal lahir", date: $viewModel.dateOfBirthPicker)
                }
                
                VStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Informasi akun")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.gray))
                            .padding(.leading, 4)
                        CerdikiawanTextField(placeholder: "Email", text: $viewModel.emailText)
                    }
                    
                    CerdikiawanSecureField(placeholder: "Password", text: $viewModel.passwordText)
                    
                    VStack(alignment: .leading) {
                        CerdikiawanSecureField(placeholder: "Konfirmasi Password", text: $viewModel.confirmPasswordText)
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundStyle(Color(.cDarkRed))
                                .padding(.leading, 8)
                        }
                    }
                }
            }
            
            VStack(spacing: 24) {
                CerdikiawanButton(type: .primary, label: "Register", action: {
                    Task {
                        if let user = try await viewModel.register() {
                            sessionData.user = user
                            
                            appRouter.pop()
                            appRouter.push(.home)
                        }
                    }
                })
                
                HStack {
                    Text("Sudah Mempunyai akun?")
                    CerdikiawanBorderlessButton(text: "Login", onTapAction: {
                        appRouter.pop()
                    })
                }
            }
        }
        .onAppear {
            viewModel.errorMessage = nil
            viewModel.nameText = ""
            viewModel.emailText = ""
            viewModel.passwordText = ""
            viewModel.confirmPasswordText = ""
            viewModel.dateOfBirthPicker = Date()
        }
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
                CerdikiawanRegisterView()
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
