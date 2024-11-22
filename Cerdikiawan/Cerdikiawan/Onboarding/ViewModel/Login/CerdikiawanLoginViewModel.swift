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
    
    private var authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func login() async throws {
        // TODO: Add validation
        guard validateLoginInfo(email: emailText, password: passwordText) else {
            return
        }
        let request = AuthRequest(email: emailText, password: passwordText)
        let (user, status) = try await authRepository.login(request: request)
        
    }
    
    private func validateLoginInfo(email: String, password: String) -> Bool {
        guard email.isEmpty == false, password.isEmpty == false else {
            return false
        }
        
        guard isValidEmail(valid: email) else {
            return false
        }
        
        //TODO: Reevaluate password validation
        guard password.count >= 8 else {
            return false
        }
        
        return true
    }
    
    private func isValidEmail(valid: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: valid)
    }
}
