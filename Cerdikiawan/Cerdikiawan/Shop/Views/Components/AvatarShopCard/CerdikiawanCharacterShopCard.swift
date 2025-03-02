//
//  CerdikiawanCharacterShopCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanCharacterShopCard: View {
    var shopCharacter: ShopCharacterEntity
    var type: CerdikiawanCharacterShopCardType
    var onTapAction: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                CerdikiawanCharacter(character: shopCharacter.character)
                VStack(alignment: .leading) {
                    Text(shopCharacter.character.name.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 0) {
                        type.displayCharacterStatus(character: shopCharacter)
                    }
                    .font(.callout)
                    .foregroundStyle(type.fontColor)
                }
                .frame(minWidth: 75)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                type.displayActionPrompt()
                    .foregroundStyle(type.fontColor)
                    .frame(maxWidth: 81, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .font(.callout)
            }
            .padding(.trailing, 24)
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .onTapGesture {
            if type != .active {
                onTapAction()
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        ScrollView {
            VStack {
                CerdikiawanCharacterShopCard(
                    shopCharacter: ShopCharacterEntity.mock()[0],
                    type: .notEnoughBalance,
                    onTapAction: {
                        debugPrint("Not Enough Balance Pressed")
                    }
                )
                CerdikiawanCharacterShopCard(
                    shopCharacter: ShopCharacterEntity.mock()[0],
                    type: .canBuy,
                    onTapAction: {
                        debugPrint("Can Buy Pressed")
                    }
                )
                CerdikiawanCharacterShopCard(
                    shopCharacter: ShopCharacterEntity.mock()[0],
                    type: .owned,
                    onTapAction: {
                        debugPrint("Owned Pressed")
                    }
                )
                CerdikiawanCharacterShopCard(
                    shopCharacter: ShopCharacterEntity.mock()[0],
                    type: .active,
                    onTapAction: {
                        debugPrint("Active Pressed")
                    }
                )
            }
        }
        .padding(16)
    }
}
