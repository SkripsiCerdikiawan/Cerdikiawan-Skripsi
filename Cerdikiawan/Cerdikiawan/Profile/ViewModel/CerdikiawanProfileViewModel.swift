//
//  CerdikiawanProfileViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 24/11/24.
//

import Foundation


class CerdikiawanProfileViewModel: ObservableObject {
    @Published var userData: UserEntity?
    @Published var nameText: String = ""
    @Published var dateOfBirthPicker: Date = Date()
    @Published var emailText: String = ""
    
    @Published var showLogoutConfirmation: Bool = false
    
    var isDataChanged: Bool {
        if let user = userData {
            if user.name != nameText || user.dateOfBirth != dateOfBirthPicker || user.email != emailText {
                return true
            }
        }
        return false
    }
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository
    
    init(authRepository: AuthRepository, profileRepository: ProfileRepository) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
    }
    
    public func setUserData(user: UserEntity) {
        self.userData = user
        self.nameText = user.name
        self.dateOfBirthPicker = user.dateOfBirth
        self.emailText = user.email
    }
    
    public func updateProfile() async throws -> UserEntity? {
        return nil
    }
    
    public func logout() async throws -> Bool {
        let (status) = try await authRepository.logout()
        if status == .success {
            return true
        }
        
        return false
    }
}
