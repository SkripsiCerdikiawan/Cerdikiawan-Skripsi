//
//  CerdikiawanRegisterViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import Foundation

class CerdikiawanRegisterViewModel: ObservableObject {
    @Published var nameText: String = ""
    @Published var dateOfBirthPicker: Date = Date()
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var confirmPasswordText: String = ""
    @Published var errorMessage: String?
    
    @Published var connectDBStatus: Bool = false
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository
    private var characterRepository: CharacterRepository
    private var ownedCharacterRepository: ProfileOwnedCharacterRepository
    
    
    init(
        authRepository: AuthRepository,
        profileRepository: ProfileRepository,
        characterRepository: CharacterRepository,
        ownedCharacterRepository: ProfileOwnedCharacterRepository
    ) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
        self.characterRepository = characterRepository
        self.ownedCharacterRepository = ownedCharacterRepository
    }
    
    @MainActor
    func register() async throws -> UserEntity? {
        guard validateRegisterInfo(name: nameText, email: emailText, dateOfBirth: dateOfBirthPicker, password: passwordText, confirmPassword: confirmPasswordText) else {
            return nil
        }
        let authRequest = AuthRequest(email: emailText, password: passwordText)
        
        do {
            let (user, userStatus) = try await authRepository.register(request: authRequest)
            
            guard let registeredUser = user, userStatus == .success else {
                errorMessage = "Akun tidak berhasil dibuat"
                return nil
            }
            
            let profileRequest = ProfileInsertRequest(profileId: registeredUser.uid,
                                                      profileName: nameText,
                                                      profileBalance: 0,
                                                      profileBirthDate: DateUtils.getDatabaseDate(from: dateOfBirthPicker)
            )
            let (profile, profileStatus) = try await profileRepository.createNewProfile(request: profileRequest)
            
            guard let registeredProfile = profile, profileStatus == .success else {
                errorMessage = "Akun tidak berhasil dibuat"
                return nil
            }
            
            errorMessage = nil
            try await setUserDefaultCharacter(userID: registeredUser.uid)
            
            return UserEntity.init(
                id: registeredUser.uid.uuidString,
                name: registeredProfile.profileName,
                email: registeredUser.email ?? "",
                balance: registeredProfile.profileBalance,
                dateOfBirth: DateUtils.getDatabaseDate(from: registeredProfile.profileBirthDate) ?? Date()
            )
            
        } catch {
            errorMessage = "Server error"
            return nil
        }
    }
    
    private func setUserDefaultCharacter(userID: UUID) async throws{
        // Fetch Default character
        let characterRequest = CharacterRequest(characterName: "Budi")
        let (character, characterStatus) = try await characterRepository.fetchCharacterById(request: characterRequest)
        
        guard let fetchedCharacter = character, characterStatus == .success else {
            errorMessage = "Gagal mendapatkan karakter default"
            throw ErrorStatus.notFound
        }
        
        // Purchase default character
        let request = ProfileOwnedCharacterInsertRequest(
            profileId: userID,
            characterId: fetchedCharacter.characterId,
            isChosen: true
        )
        
        let (ownedCharacter, ownedCharacterStatus) = try await ownedCharacterRepository.insertProfileOwnedCharacter(request: request)
        guard ownedCharacter != nil, ownedCharacterStatus == .success else {
            errorMessage = "Gagal memasang default character"
            throw ErrorStatus.serverError
        }
    }
    
    private func validateRegisterInfo(name: String, email: String, dateOfBirth: Date, password: String, confirmPassword: String) -> Bool {
        guard isValidName(name: name) else {
            errorMessage = "Nama harus memiliki minimal 3 karakter"
            return false
        }
        
        guard isValidDateOfbirth(dateOfBirth: dateOfBirth) else {
            errorMessage = "Tanggal Lahir tidak boleh lebih dari hari ini"
            return false
        }
        
        guard isValidEmail(email: email) else {
            errorMessage = "Email invalid"
            return false
        }
        
        guard isValidPassword(password: password) else {
            errorMessage = "Password harus memiliki minimal 8 karakter"
            return false
        }
        
        guard isPasswordConfirmed(password: password, confirmPassword: confirmPassword) else {
            errorMessage = "Konfirmasi password tidak sesuai"
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
    
    private func isValidPassword(password: String) -> Bool {
        return password.count >= 8
    }
    
    private func isPasswordConfirmed(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    private func isValidEmail(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
