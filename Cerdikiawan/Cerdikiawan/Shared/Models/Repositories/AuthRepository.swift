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
    //singleton
    public static let shared = SupabaseAuthRepository()
    private override init() {}
    
    //login user into the app
    func login(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            //sign in function that return a session
            let session = try await client.auth.signIn(email: request.email, password: request.password)
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    //register new user
    func register(request: AuthRequest) async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            //register function that also return a session
            let response = try await client.auth.signUp(email: request.email, password: request.password)
            guard let session = response.session else {
                debugPrint("no session when registering user")
                return (nil, .serverError)
            }
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return(nil, .serverError)
        }
    }
    
    //get the current user session (as long as the user haven't signed out yet)
    func getSession() async throws -> (SupabaseUser?, ErrorStatus) {
        do {
            let session = try await client.auth.session
            return (SupabaseUser(uid: session.user.id, email: session.user.email), .success)
        } catch {
            return (nil, .serverError)
        }
    }
    
    //logout user and pop session
    func logout() async throws -> (ErrorStatus) {
        do {
            try await client.auth.signOut()
            
            return(.success)
        } catch {
            return(.serverError)
        }
    }
}
