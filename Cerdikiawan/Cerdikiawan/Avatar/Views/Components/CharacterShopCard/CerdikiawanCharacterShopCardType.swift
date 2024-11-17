//
//  CerdikiawanCharacterShopCardType.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import Foundation
import SwiftUI

enum CerdikiawanCharacterShopCardType {
    case canBuy
    case notEnoughBalance
    case owned
    case active
    
    var fontColor: Color {
        switch self {
        case .canBuy:
            return Color(.cDarkBlue)
        case .notEnoughBalance:
            return Color(.cDarkRed)
        case .owned:
            return Color(.cDarkOrange)
        case .active:
            return Color(.cDarkBlue)
        }
    }
    
    @ViewBuilder
    func displayAvatarStatus(avatar: ShopAvatarEntity) -> some View {
        switch self {
        case .canBuy:
            HStack(spacing: 0) {
                Image(systemName: "dollarsign.square.fill")
                Text("\(avatar.price)")
            }
        case .notEnoughBalance:
            HStack(spacing: 0) {
                Image(systemName: "dollarsign.square.fill")
                Text("\(avatar.price)")
            }
        case .owned:
            Text("Dimiliki")
        case .active:
            Text("Dipakai")
                .fontWeight(.bold)
        }
    }
    
    @ViewBuilder
    func displayActionPrompt() -> some View {
        switch self {
        case .canBuy:
            HStack {
                Text("Beli")
                Image(systemName: "chevron.forward")
            }
        case .notEnoughBalance:
            HStack {
                Text("Poin tidak mencukupi")
            }
        case .owned:
            HStack {
                Text("Pakai")
                Image(systemName: "chevron.forward")
            }
        case .active:
            HStack {
                Image(systemName: "checkmark")
            }
        }
    }
}

extension CerdikiawanCharacterShopCardType: Equatable {
    // Conform to equatable
    static func == (lhs: CerdikiawanCharacterShopCardType, rhs: CerdikiawanCharacterShopCardType) -> Bool {
        switch (lhs, rhs){
        case (.canBuy, .canBuy),
            (.notEnoughBalance, .notEnoughBalance),
            (.owned, .owned),
            (.active, .active):
            return true
        default:
            return false
        }
        
    }
}
