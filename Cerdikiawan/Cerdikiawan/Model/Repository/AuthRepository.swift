//
//  AuthRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 20/11/24.
//

import Foundation

protocol AuthRepository {
    func login(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus)
    func register(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus)
    func getSession() async throws -> (SupabaseUser?, ErrorStatus)
    func logout() async throws -> (ErrorStatus)
}

class SupabaseAuthRepository: SupabaseRepository, AuthRepository {
    public static let shared = SupabaseAuthRepository()
    private override init() {}
    
    func login(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            let session = try await client.auth.signIn(email: request.email, password: request.password)
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    func register(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            let response = try await client.auth.signUp(email: request.email, password: request.password)
            guard let session = response.session else {
                print("no session when registering user")
                return (nil, .serverError)
            }
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return(nil, .serverError)
        }
    }
    
    func getSession() async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            let session = try await client.auth.session
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    func logout() async throws -> (ErrorStatus) {
        do {
            try await client.auth.signOut()
            
            return(.success)
        } catch {
            return(.serverError)
        }
    }
}
