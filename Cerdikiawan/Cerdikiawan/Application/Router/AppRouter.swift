//
//  AppRouter.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 20/11/24.
//

import Foundation
import SwiftUI

class AppRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    @Published var startScreen: Screen?
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .login:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanLoginView()
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        case .register:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanRegisterView()
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        case .home:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanHomeView()
                }
                .navigationBarBackButtonHidden()
            }
        case .searchLevel:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    Text("Not yet implemented")
                    CerdikiawanButton(
                        label: "Back",
                        action: {
                            self.pop()
                        }
                    )
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        case .practice(let story):
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanStoryView(story: story)
                }
                .navigationBarBackButtonHidden()
            }
        case .storyCompletion(let result, let character, let onCompletion):
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanResultView(
                        character: character,
                        resultData: result,
                        onCompletionTap: onCompletion
                    )
                }
                .navigationBarBackButtonHidden()
            }
        case .profile:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanProfileView()
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        case .reportDetail(let reportEntity):
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    Text("Not yet implemented")
                    CerdikiawanButton(
                        label: "Back",
                        action: {
                            self.pop()
                        }
                    )
                    .onAppear(){
                        debugPrint("Report \(reportEntity.storyName) is pressed")
                    }
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        case .buyConfirmation(let shopCharacter):
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanBuyingConfirmationView(character: shopCharacter)
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
                .onAppear() {
                    debugPrint("Buying \(shopCharacter.character.name)")
                }
            }
        case .shop:
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanShopView()
                }
                .safeAreaPadding(.horizontal, 16)
                .navigationBarBackButtonHidden()
            }
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .page(let page):
            ZStack {
                Color(.cGray).ignoresSafeArea()
                VStack {
                    CerdikiawanPageView(page: page)
                    CerdikiawanButton(
                        label: "Tutup",
                        action: {
                            self.dismissSheet()
                        }
                    )
                }
                .safeAreaPadding(.horizontal, 16)
                .safeAreaPadding(.bottom, 16)
                .safeAreaPadding(.top, 32)
            }
        }
    }
}
