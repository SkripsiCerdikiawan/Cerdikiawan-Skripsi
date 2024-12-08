//
//  CerdikiawanLoginViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 22/11/24.
//

import Foundation

class CerdikiawanLoginViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var errorMessage: String?
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository
    
    init(authRepository: AuthRepository, profileRepository: ProfileRepository) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
    }
    
    @MainActor
    func login() async throws -> UserEntity? {
        guard validateLoginInfo(email: emailText, password: passwordText) else {
            return nil
        }
        let authRequest = AuthRequest(email: emailText, password: passwordText)
        
        do {
            let (user, userStatus) = try await authRepository.login(request: authRequest)
            
            guard let loggedInUser = user, userStatus == .success else {
                errorMessage = "Akun tidak ditemukan"
                return nil
            }
            
            let profileRequest = ProfileFetchRequest(profileId: loggedInUser.uid)
            let (profile, profileStatus) = try await profileRepository.fetchProfile(request: profileRequest)
            
            guard let loggedInProfile = profile, profileStatus == .success else {
                errorMessage = "Akun tidak ditemukan"
                return nil
            }
            errorMessage = nil
            return UserEntity.init(
                id: loggedInUser.uid.uuidString,
                name: loggedInProfile.profileName,
                email: loggedInUser.email ?? "",
                balance: loggedInProfile.profileBalance,
                dateOfBirth: DateUtils.getDatabaseDate(from: loggedInProfile.profileBirthDate) ?? Date()
            )
            
        } catch {
            errorMessage = "Server error"
            return nil
        }
    }
    
    
    private func validateLoginInfo(email: String, password: String) -> Bool {
        do {
            guard email.isEmpty == false, password.isEmpty == false else {
                errorMessage = "Kedua kolom harus diisi"
                return false
            }
            
            guard isValidEmail(valid: email) else {
                errorMessage = "Email tidak valid"
                return false
            }
            
            return true
        }
    }
    
    private func isValidEmail(valid: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: valid)
    }
}
