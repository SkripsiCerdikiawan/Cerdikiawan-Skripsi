//
//  ShopAvatarViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

class ShopAvatarViewModel: ObservableObject {
    @Published var userBalance: Int = 0
    @Published var activeAvatarID: String = ""
    @Published var ownedAvatarID: [String] = []
    
    @Published var avatarList: [ShopAvatarEntity] = [] {
        didSet {
            displayedOwnedAvatarList = avatarList.filter({ ownedAvatarID.contains($0.avatar.id)})
            displayedUnownedAvatarList = avatarList.filter({ ownedAvatarID.contains($0.avatar.id) == false })
        }
    }
    
    @Published var displayedOwnedAvatarList: [ShopAvatarEntity] = []
    @Published var displayedUnownedAvatarList: [ShopAvatarEntity] = []
    
    func setup(
        user: UserEntity
    ){
        // Fetch Data from Repo
        userBalance = user.balance
        activeAvatarID = fetchActiveAvatarID(userID: user.id)
        ownedAvatarID = fetchOwnedAvatarID(userID: user.id)
        avatarList = fetchAllAvailableAvatar()
        
    }
    
    // TODO: Replace with repo
    func fetchAllAvailableAvatar() -> [ShopAvatarEntity] {
        return ShopAvatarEntity.mock()
    }
    
    // TODO: Replace with repo
    func fetchOwnedAvatarID(userID: String) -> [String] {
        let mock = ShopAvatarEntity.mock().map({ $0.avatar.id })
        return [
            mock[0],
            mock[1]
        ]
    }
    
    // TODO: Replace with repo
    func fetchActiveAvatarID(userID: String) -> String {
        return ShopAvatarEntity.mock()[0].avatar.id
    }
    
    // TODO: Replace with Repo
    func setActiveAvatar(userID: String, avatar: AvatarEntity) {
        guard self.activeAvatarID != avatar.id else {
            debugPrint("Error! Active Character ID is the same with to select avatar")
            return
        }
        self.activeAvatarID = avatar.id
        debugPrint("Set new active character")
    }
    
    // MARK: - Business Logic
    func determineAvatarState(shopAvatar: ShopAvatarEntity) -> CerdikiawanAvatarShopCardType {
        if shopAvatar.avatar.id == activeAvatarID {
            return .active
        }
        
        if ownedAvatarID.contains(shopAvatar.avatar.id) {
            return .owned
        }
        
        if shopAvatar.price > userBalance {
            return .notEnoughBalance
        }
        
        return .canBuy
    }
    
    func validateUserBalance(shopAvatar: ShopAvatarEntity) -> Bool {
        if shopAvatar.price <= userBalance {
            return true
        }
        return false
    }
}
