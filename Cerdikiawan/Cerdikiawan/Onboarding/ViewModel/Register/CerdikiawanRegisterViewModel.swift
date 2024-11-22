//
//  CerdikiawanRegisterViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import Foundation

class CerdikiawanRegisterViewModel: ObservableObject {
    @Published var nameText: String = ""
    @Published var dateOfBirthText: String = ""
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var confirmPasswordText: String = ""
    @Published var errorText: String?
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository
    
    init(authRepository: AuthRepository, profileRepository: ProfileRepository) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
    }
    
    @MainActor
    public func register() async throws -> UserEntity? {
        return nil
    }
    
    private func isValidEmail(valid: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: valid)
    }
}
