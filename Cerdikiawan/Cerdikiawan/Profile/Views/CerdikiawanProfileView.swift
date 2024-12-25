//
//  CerdikiawanProfileView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 24/11/24.
//

import SwiftUI

struct CerdikiawanProfileView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: CerdikiawanProfileViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared,
                profileRepository: SupabaseProfileRepository.shared
            )
        )
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                VStack (spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Data diri anak")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.gray))
                            .padding(.leading, 4)
                        CerdikiawanTextField(placeholder: "Nama lengkap anak", text: $viewModel.nameText)
                    }
                    VStack (alignment: .leading) {
                        CerdikiawanDatePickerField(placeholder: "Tanggal lahir anak", date: $viewModel.dateOfBirthPicker)
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundStyle(Color(.cDarkRed))
                                .padding(.leading, 8)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("Akun")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(Color(.gray))
                        .padding(.leading, 4)
                    CerdikiawanTextField(placeholder: "Email", text: $viewModel.emailText, state: .disabled)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                if viewModel.isDataChanged {
                    CerdikiawanButton(
                        type: viewModel.determineButtonState(),
                        label: "Simpan perubahan data",
                        action: {
                            viewModel.connectDBStatus = true
                            Task {
                                if let user = try await viewModel.updateProfile() {
                                    sessionData.user = user
                                }
                                viewModel.connectDBStatus = false
                            }
                        }
                    )
                }
                
                CerdikiawanButton(type: .destructive, label: "Keluar", action: {
                    viewModel.showLogoutConfirmation = true
                })
            }
        }
        .padding(.bottom, 40)
        .alert("Konfirmasi Keluar", isPresented: $viewModel.showLogoutConfirmation) {
                    Button("Batalkan", role: .cancel) { }
                    Button("Keluar", role: .destructive) {
                        Task {
                            let logoutStatus = try await viewModel.logout()
                            
                            if logoutStatus {
                                sessionData.user = nil
                                appRouter.startScreen = .login
                                appRouter.popToRoot()
                            }
                        }
                    }
                } message: {
                    Text("Apakah Anda yakin untuk keluar dari akun ini?")
                }
        .onAppear {
            if let user = sessionData.user {
                viewModel.setUserData(user: user)
            }
        }
        .safeAreaPadding(.top, 32)
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(
                    action: {
                        if !viewModel.connectDBStatus {
                            appRouter.popToRoot()
                        }
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
        .overlay(content: {
            // Show loading bar overlay when updating data
            // To make sure the user won't do any operation
            if viewModel.connectDBStatus {
                ZStack {
                    Color.gray.opacity(0.5)
                    ProgressView("Sedang mengubah data...")
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(Color.black)
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
                CerdikiawanProfileView()
            }
            .navigationDestination(for: Screen.self, destination: { screen in
                appRouter.build(screen)
            })
        }
        .safeAreaPadding(.horizontal, 16)
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
