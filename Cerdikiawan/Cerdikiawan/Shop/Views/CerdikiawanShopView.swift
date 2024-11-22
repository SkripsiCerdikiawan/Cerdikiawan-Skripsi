//
//  CerdikiawanShopView.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import SwiftUI

struct CerdikiawanShopView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: ShopCharacterViewModel = .init()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack (alignment: .leading){
                    Text("Karakter")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.cWhite))
                    Text("Kustomisasi karakter yang menemani kamu selama membaca")
                        .font(.callout)
                        .foregroundStyle(Color(.cWhite))
                }
                
                VStack(alignment: .leading) {
                    Text("Poin yang dimiliki")
                        .font(.subheadline)
                    HStack(spacing: 4, content: {
                        Image(systemName: "dollarsign.square.fill")
                        Text("\(viewModel.userBalance)")
                    })
                    .font(.title3)
                    .fontWeight(.bold)
                }
                .foregroundStyle(Color(.cWhite))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack(spacing: 32) {
                    if viewModel.characterList.isEmpty == false {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Karakter yang dimiliki")
                                .font(.body)
                                .foregroundStyle(Color(.secondaryLabel))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(viewModel.displayedOwnedCharacterList, id: \.character.id, content: { shopCharacter in
                                CerdikiawanCharacterShopCard(
                                    shopCharacter: shopCharacter,
                                    type: viewModel.determineCharacterState(shopCharacter: shopCharacter),
                                    onTapAction: {
                                        if let user = sessionData.user {
                                            viewModel.setActiveCharacter(
                                                userID: user.id,
                                                character: shopCharacter.character
                                            )
                                        }
                                    }
                                )
                            })
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Karakter yang belum dimiliki")
                                .font(.body)
                                .foregroundStyle(Color(.secondaryLabel))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(viewModel.displayedUnownedCharacterList, id: \.character.id, content: { shopCharacter in
                                CerdikiawanCharacterShopCard(
                                    shopCharacter: shopCharacter,
                                    type: viewModel.determineCharacterState(shopCharacter: shopCharacter),
                                    onTapAction: {
                                        let canBuy = viewModel.validateUserBalance(shopCharacter: shopCharacter)
                                        if canBuy {
                                            appRouter.push(.buyConfirmation(shopCharacter: shopCharacter))
                                        }
                                    }
                                )
                            })
                        }
                    }
                    else {
                        Text("No Characters Data")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
                .safeAreaPadding(.horizontal, 16)
                .safeAreaPadding(.vertical, 32)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.cGray))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    topTrailingRadius: 16
                )
            )
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .scrollIndicators(.hidden)
        }
        .background(
            Color(.cDarkBlue)
                .ignoresSafeArea(.container, edges: .top)
        )
        .onAppear(){
            if let user = sessionData.user {
                viewModel.setup(user: user)
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
                CerdikiawanShopView()
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

