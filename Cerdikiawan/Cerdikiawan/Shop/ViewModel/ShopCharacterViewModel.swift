//
//  ShopCharacterViewModel.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 21/11/24.
//

import Foundation

class ShopCharacterViewModel: ObservableObject {
    @Published var userBalance: Int = 0
    @Published var activeCharacterID: String = ""
    @Published var ownedCharacterID: [String] = []
    
    @Published var characterList: [ShopCharacterEntity] = [] {
        didSet {
            displayedOwnedCharacterList = characterList.filter({ ownedCharacterID.contains($0.character.id)})
            displayedUnownedCharacterList = characterList.filter({ ownedCharacterID.contains($0.character.id) == false })
        }
    }
    
    @Published var displayedOwnedCharacterList: [ShopCharacterEntity] = []
    @Published var displayedUnownedCharacterList: [ShopCharacterEntity] = []
    
    func setup(
        user: UserEntity
    ){
        // Fetch Data from Repo
        userBalance = user.balance
        activeCharacterID = fetchActiveCharacterID(userID: user.id)
        ownedCharacterID = fetchOwnedCharacterID(userID: user.id)
        characterList = fetchAllAvailableCharacter()
        
    }
    
    // TODO: Replace with repo
    func fetchAllAvailableCharacter() -> [ShopCharacterEntity] {
        return ShopCharacterEntity.mock()
    }
    
    // TODO: Replace with repo
    func fetchOwnedCharacterID(userID: String) -> [String] {
        let mock = ShopCharacterEntity.mock().map({ $0.character.id })
        return [
            mock[0],
            mock[1]
        ]
    }
    
    // TODO: Replace with repo
    func fetchActiveCharacterID(userID: String) -> String {
        return ShopCharacterEntity.mock()[0].character.id
    }
    
    // TODO: Replace with Repo
    func setActiveCharacter(userID: String, character: CharacterEntity) {
        guard self.activeCharacterID != character.id else {
            debugPrint("Error! Active Character ID is the same with to select character")
            return
        }
        self.activeCharacterID = character.id
        debugPrint("Set new active character")
    }
    
    // MARK: - Business Logic
    func determineCharacterState(shopCharacter: ShopCharacterEntity) -> CerdikiawanCharacterShopCardType {
        if shopCharacter.character.id == activeCharacterID {
            return .active
        }
        
        if ownedCharacterID.contains(shopCharacter.character.id) {
            return .owned
        }
        
        if shopCharacter.price > userBalance {
            return .notEnoughBalance
        }
        
        return .canBuy
    }
    
    func validateUserBalance(shopCharacter: ShopCharacterEntity) -> Bool {
        if shopCharacter.price <= userBalance {
            return true
        }
        return false
    }
}
