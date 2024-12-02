//
//  AuthTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 20/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct AuthTests {
    var authRepository: AuthRepository
    
    init() async throws {
        authRepository = SupabaseAuthRepository.shared
    }
    
    @Test func testRegister() async throws {
        let request = AuthRequest(email: "test783@test.com", password: "test789")
        let (result, status) = try await authRepository.register(request: request)
        
        #expect(status == .success, "Registration failed")
        #expect(result?.uid != nil, "UID is nil, user not registered")
    }

    @Test func testLogin() async throws {
        let request = AuthRequest(email: "def456@gmail.com", password: "def456")
        let (result, status) = try await authRepository.login(request: request)
        
        #expect(status == .success, "Login failed")
        #expect(result?.uid != nil, "UID is nil, user not login")
    }
    
    @Test func testGetCurrentSession() async throws {
        try await testLogin()
        let (result, status) = try await authRepository.getSession()
        
        #expect(status == .success, "Getting current session failed")
        #expect(result?.uid == UUID(uuidString: "9ebd74db-a0f0-4338-841a-36db80fa6aa7"), "UID doesnt match, session not get")
    }
    
    @Test func testLogout() async throws {
        try await testGetCurrentSession()
        
        let (status) = try await authRepository.logout()
        
        #expect(status == .success, "Logout failed")
    }
}
