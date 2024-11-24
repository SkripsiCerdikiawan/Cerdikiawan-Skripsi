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
                    CerdikiawanDatePickerField(placeholder: "Tanggal lahir anak", date: $viewModel.dateOfBirthPicker)
                }
                VStack {
                    Text("Akun")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(Color(.gray))
                        .padding(.leading, 4)
                    CerdikiawanTextField(placeholder: "Email", text: $viewModel.emailText, state: .disabled)
                }
            }
            
            Spacer()
            
            if viewModel.isDataChanged {
                CerdikiawanButton(type: .primary, label: "Simpan perubahan data", action: {
                    Task {
                        try await viewModel.updateProfile()
                    }
                })
            }
            
            CerdikiawanButton(type: .destructive, label: "Keluar", action: {
                Task {
                    let logoutStatus = try await viewModel.logout()
                    
                    if logoutStatus {
                        sessionData.user = nil
                        appRouter.popToRoot()
                    }
                }
            })
        }
        .alert("Konfirmasi Keluar", isPresented: $viewModel.showLogoutConfirmation) {
                    Button("Batalkan", role: .cancel) { }
                    Button("Keluar", role: .destructive) {
                        Task {
                            let logoutStatus = try await viewModel.logout()
                            
                            if logoutStatus {
                                sessionData.user = nil
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
                CerdikiawanProfileView()
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
