//
//  CerdikiawanLoginView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 22/11/24.
//

import SwiftUI

struct CerdikiawanLoginView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    @StateObject private var viewModel: CerdikiawanLoginViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared
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
                CerdikiawanButton(type: .primary, label: "Masuk", action: {
                    Task {
                        try await viewModel.login()
                        if viewModel.errorMessage == nil {
                            appRouter.push(.home)
                        }
                    }
                })
                
                HStack {
                    Text("Tidak Mempunyai akun?")
                    CerdikiawanBorderlessButton(text: "Daftar disini", onTapAction: {
                        appRouter.push(.register)
                    })
                }
            }
        }
        
    }
}

#Preview {
    CerdikiawanLoginView()
}
