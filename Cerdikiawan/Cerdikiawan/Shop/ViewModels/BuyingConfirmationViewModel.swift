//
//  BuyingConfirmationViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 24/11/24.
//

import SwiftUI

class BuyingConfirmationViewModel: ObservableObject {
    @Published var userData: UserEntity?
    @Published var shopCharacter: ShopCharacterEntity
    
    @Published var errorMessage: String?
    @Published var confirmationAlertShowed: Bool = false
    
    @Published var connectDBStatus: Bool = false
    
    private var profileRepository: ProfileRepository
    private var userCharacterRepository: ProfileOwnedCharacterRepository
    
    init(shopCharacter: ShopCharacterEntity, profileRepository: ProfileRepository, userCharacterRepository: ProfileOwnedCharacterRepository) {
        self.shopCharacter = shopCharacter
        self.profileRepository = profileRepository
        self.userCharacterRepository = userCharacterRepository
    }
    
    func setUserData(user: UserEntity) {
        self.userData = user
    }
    
    @MainActor
    func buyCharacter() async throws -> Bool {
        guard let user = userData else {
            errorMessage = "Data user tidak ditemukan"
            return false
        }
        
        guard let userId = UUID(uuidString: user.id), let characterId = UUID(uuidString: shopCharacter.character.id) else {
            errorMessage = "Data profil atau karakter tidak ditemukan"
            return false
        }
        
        do {
            let request = ProfileOwnedCharacterInsertRequest(profileId: userId,
                                                             characterId: characterId,
                                                             isChosen: false
            )
            let (character, errorStatus) = try await userCharacterRepository.insertProfileOwnedCharacter(request: request)
            
            if character != nil && errorStatus == .success, let userId = UUID(uuidString: user.id) {
                let profileRequest = ProfileUpdateRequest(profileId: userId,
                                                          profileBalance: user.balance - shopCharacter.price
                )
                let (profile, profileStatus) = try await profileRepository.updateProfile(request: profileRequest)
                
                guard profileStatus == .success, profile != nil else {
                    debugPrint("Failed to update user profile balance")
                    return false
                }
                
                errorMessage = nil
                return true
            }else {
                errorMessage = "Pembelian tidak berhasil"
                return false
            }
        } catch {
            return false
        }
    }
}
