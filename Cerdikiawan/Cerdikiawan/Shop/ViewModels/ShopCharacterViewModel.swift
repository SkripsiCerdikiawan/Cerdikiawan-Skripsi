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
    
    private var shopRepository: ShopRepository
    private var characterRepository: CharacterRepository
    private var ownedCharacterRepository: ProfileOwnedCharacterRepository
    
    init(shopRepository: ShopRepository, characterRepository: CharacterRepository, ownedCharacterRepository: ProfileOwnedCharacterRepository) {
        self.shopRepository = shopRepository
        self.characterRepository = characterRepository
        self.ownedCharacterRepository = ownedCharacterRepository
    }
    
    @MainActor
    func setup(
        user: UserEntity
    ) async throws {
        // Fetch Data from Repo
        userBalance = user.balance
        ownedCharacterID = try await fetchOwnedCharacterID(userID: user.id)
        characterList = try await fetchAllAvailableCharacter()
        
    }
    
    @MainActor
    func fetchAllAvailableCharacter() async throws -> [ShopCharacterEntity] {
        var shopEntities: [ShopCharacterEntity] = []
        let (shops, shopStatus) = try await shopRepository.fetchShopItems()
        let (characters, characterStatus) = try await characterRepository.fetchCharacters()
        
        guard shopStatus == .success, characterStatus == .success else {
            debugPrint("Database not fetched")
            return []
        }
        
        for shop in shops {
            if let character = characters.first(where: { $0.characterId == shop.characterShopId}) {
                let characterEntity = CharacterEntity(id: character.characterId.uuidString,
                                                      name: character.characterName,
                                                      imagePath: character.characterImagePath,
                                                      description: character.characterDescription
                )
                let shopEntity = ShopCharacterEntity(character: characterEntity, price: shop.shopPrice)
                shopEntities.append(shopEntity)
            }
        }
        return shopEntities
    }
    
    
    @MainActor
    func fetchOwnedCharacterID(userID: String) async throws -> [String] {
        var charactersId: [String] = []
        guard let loggedInUserId = UUID(uuidString: "\(userID)") else {
            debugPrint("User Id cannot be resolved")
            return []
        }
        let request = ProfileOwnedCharacterFetchRequest(profileId: loggedInUserId)
        let (ownedCharacters, status) = try await ownedCharacterRepository.fetchProfileOwnedCharacter(request: request)
        
        guard status == .success else {
            debugPrint("Error fetching owned characters")
            return []
        }
        
        for character in ownedCharacters {
            charactersId.append(character.characterId.uuidString)
            if character.isChosen {
                self.activeCharacterID = character.characterId.uuidString
            }
        }
        
        return charactersId
    }
    
    @MainActor
    func setActiveCharacter(userID: String, character: CharacterEntity) async throws {
        guard let loggedInUserId = UUID(uuidString: "\(userID)") else {
            debugPrint("User Id cannot be resolved")
            return
        }
        
        guard let newCharacter = UUID(uuidString: "\(character.id)") else {
            debugPrint("new character Id cannot be resolved")
            return
        }
        
        guard let equippedCharacter = UUID(uuidString: "\(activeCharacterID)") else {
            debugPrint("Active character Id cannot be resolved")
            return
        }
        
        guard self.activeCharacterID != character.id else {
            debugPrint("Error! Active Character ID is the same with to select character")
            return
        }
        
        let oldRequest = ProfileOwnedCharacterUpdateRequest(profileId: loggedInUserId,
                                                         characterId: equippedCharacter,
                                                         isChosen: false
        )
        let (oldCharacter, deactivateStatus) = try await ownedCharacterRepository.updateProfileOwnedCharacter(request: oldRequest)
        
        guard oldCharacter != nil && deactivateStatus == .success else {
            debugPrint("Failed to deactivate equipped character")
            return
        }
        
        let newRequest = ProfileOwnedCharacterUpdateRequest(profileId: loggedInUserId,
                                                         characterId: newCharacter,
                                                         isChosen: true
        )
        let (updatedNewCharacter, activateStatus) = try await ownedCharacterRepository.updateProfileOwnedCharacter(request: newRequest)
        
        guard updatedNewCharacter != nil && activateStatus == .success else {
            debugPrint("Failed to activate new character")
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
