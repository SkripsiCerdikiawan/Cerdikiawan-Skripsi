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
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    @MainActor
    public func login() async throws {
        guard validateLoginInfo(email: emailText, password: passwordText) else {
            return
        }
        let request = AuthRequest(email: emailText, password: passwordText)
        
        do {
            let (user, status) = try await authRepository.login(request: request)
            
            if user == nil && status != .success {
                errorMessage = "Invalid credentials"
            } else {
                errorMessage = nil
            }
        } catch {
            errorMessage = "An unexpected error occurred"
        }
    }
    
    
    private func validateLoginInfo(email: String, password: String) -> Bool {
        do {
            guard email.isEmpty == false, password.isEmpty == false else {
                errorMessage = "Field must not be empty"
                return false
            }
            
            guard isValidEmail(valid: email) else {
                errorMessage = "Invalid email"
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
