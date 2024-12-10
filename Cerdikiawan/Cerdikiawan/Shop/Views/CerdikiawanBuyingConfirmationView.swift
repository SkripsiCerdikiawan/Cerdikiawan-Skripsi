//
//  CerdikiawanBuyingConfirmationView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 24/11/24.
//

import SwiftUI

struct CerdikiawanBuyingConfirmationView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: BuyingConfirmationViewModel
    
    init(character: ShopCharacterEntity) {
        _viewModel = .init(
            wrappedValue: .init(
                shopCharacter: character,
                profileRepository: SupabaseProfileRepository.shared,
                userCharacterRepository: SupabaseProfileOwnedCharacterRepository.shared
            )
        )
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image("\(viewModel.shopCharacter.character.imagePath)_DEFAULT")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 131, height: 177)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Apakah kamu ingin membeli karakter ini?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cBlack))
                    
                    VStack (alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Harga")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(.cBlack))
                            HStack(spacing: 2) {
                                Image(systemName: "dollarsign.square.fill")
                                Text("\(viewModel.shopCharacter.price)")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.cDarkBlue))
                        }
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text("Deskripsi Karakter")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundStyle(Color(.cBlack))
                            
                            Text("\(viewModel.shopCharacter.character.description)")
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundStyle(Color(.gray))
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4){
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundStyle(Color(.cDarkRed))
                            .padding(.leading, 8)
                    }
                    CerdikiawanButton(type: .primary, label: "Konfirmasi Beli", action: {
                        Task{
                            let result = try await viewModel.buyCharacter()
                            
                            if result {
                                sessionData.user?.balance -= viewModel.shopCharacter.price
                                viewModel.confirmationAlertShowed = true
                            }
                        }
                    })
                }
                
                
                CerdikiawanButton(type: .destructive, label: "Batalkan", action: {
                    appRouter.pop()
                })
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 40)
        .alert("Sukses", isPresented: $viewModel.confirmationAlertShowed) {
            Button("Mengerti") {
                appRouter.pop()
            }
        } message: {
            Text("Kamu berhasil membeli karakter ini!")
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
    @StateObject var sessionData: SessionData = .init(
        authRepository: SupabaseAuthRepository.shared,
        profileRepository: SupabaseProfileRepository.shared
    )
    
    NavigationStack(path: $appRouter.path) {
        ZStack {
            Color(.cGray).ignoresSafeArea()
            VStack {
                CerdikiawanBuyingConfirmationView(character: .mock()[0])
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
