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
    @Published var errorMessage: String?
    
    @Published var showLogoutConfirmation: Bool = false
    
    @Published var connectDBStatus: Bool = false
    
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
    
    func setUserData(user: UserEntity) {
        self.userData = user
        self.nameText = user.name
        self.dateOfBirthPicker = user.dateOfBirth
        self.emailText = user.email
    }
    
    @MainActor
    func updateProfile() async throws -> UserEntity? {
        guard validateUpdateProfile(name: nameText, dateOfBirth: dateOfBirthPicker) else {
            return nil
        }
        guard let user = userData, let userId = UUID(uuidString: user.id) else {
            return nil
        }
        
        do {
            let profileUpdateRequest = ProfileUpdateRequest(profileId: userId, profileName: nameText, profileBirthDate: DateUtils.getDatabaseDate(from: dateOfBirthPicker))
            
            let (profile, profileStatus) = try await profileRepository.updateProfile(request: profileUpdateRequest)
            
            guard let updatedProfile = profile, profileStatus == .success else {
                errorMessage = "Perbaruan informasi tidak berhasil"
                return nil
            }
            
            errorMessage = nil
            
            userData = UserEntity(id: user.id,
                                  name: updatedProfile.profileName,
                                  email: emailText,
                                  balance: updatedProfile.profileBalance,
                                  dateOfBirth: DateUtils.getDatabaseDate(from: updatedProfile.profileBirthDate) ?? Date()
                )
            
            return userData
        } catch {
            errorMessage = "Perbaruan informasi tidak berhasil"
            return nil
        }
    }
    
    private func validateUpdateProfile(name: String, dateOfBirth: Date) -> Bool {
        guard isValidName(name: name) else {
            errorMessage = "Nama harus memiliki minimal 3 karakter"
            return false
        }
        
        guard isValidDateOfbirth(dateOfBirth: dateOfBirth) else {
            errorMessage = "Tanggal Lahir tidak boleh lebih dari hari ini"
            return false
        }
        
        return true
    }
    
    private func isValidDateOfbirth(dateOfBirth: Date) -> Bool {
        return dateOfBirth < Date.now
    }
    
    private func isValidName(name: String) -> Bool {
        return name.count >= 3
    }
    
    func logout() async throws -> Bool {
        let (status) = try await authRepository.logout()
        if status == .success {
            return true
        }
        
        return false
    }
    
    // MARK: - UI Logic
    func determineButtonState() -> CerdikiawanButtonType {
        return connectDBStatus ? .loading : .primary
    }
}
