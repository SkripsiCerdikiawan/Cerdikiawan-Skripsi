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
                    // TODO: Change this maybe to handle birth date
                    CerdikiawanTextField(placeholder: "Tanggal lahir", text: $viewModel.dateOfBirthText)
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
                    
                    CerdikiawanTextField(placeholder: "Password", text: $viewModel.passwordText)
                    
                    VStack {
                        CerdikiawanTextField(placeholder: "Konfirmasi Password", text: $viewModel.passwordText)
                        
                    }
                }
            }
            
            VStack(spacing: 24) {
                CerdikiawanButton(type: .primary, label: "Register", action: {
                    Task {
                        if let user = try await viewModel.register() {
                            sessionData.user = user
                            
                            //TODO: Check if this is best practice
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
    }
}

#Preview {
    CerdikiawanRegisterView()
}
