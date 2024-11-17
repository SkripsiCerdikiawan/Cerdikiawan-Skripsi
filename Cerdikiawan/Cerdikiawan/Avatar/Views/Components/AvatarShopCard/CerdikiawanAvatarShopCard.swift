//
//  CerdikiawanCharacterShopCard.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 17/11/24.
//

import SwiftUI

struct CerdikiawanAvatarShopCard: View {
    var shopAvatar: ShopAvatarEntity
    var type: CerdikiawanAvatarShopCardType
    var onTapAction: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                CerdikiawanAvatar(avatar: shopAvatar.avatar)
                VStack(alignment: .leading) {
                    Text(shopAvatar.avatar.name.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 0) {
                        type.displayAvatarStatus(avatar: shopAvatar)
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
                    .frame(maxWidth: 81)
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
                CerdikiawanAvatarShopCard(
                    shopAvatar: ShopAvatarEntity.mock()[0],
                    type: .notEnoughBalance,
                    onTapAction: {
                        debugPrint("Not Enough Balance Pressed")
                    }
                )
                CerdikiawanAvatarShopCard(
                    shopAvatar: ShopAvatarEntity.mock()[0],
                    type: .canBuy,
                    onTapAction: {
                        debugPrint("Can Buy Pressed")
                    }
                )
                CerdikiawanAvatarShopCard(
                    shopAvatar: ShopAvatarEntity.mock()[0],
                    type: .owned,
                    onTapAction: {
                        debugPrint("Owned Pressed")
                    }
                )
                CerdikiawanAvatarShopCard(
                    shopAvatar: ShopAvatarEntity.mock()[0],
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
