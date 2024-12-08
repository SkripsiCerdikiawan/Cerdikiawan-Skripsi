//
//  ApplicationViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 02/12/24.
//

import Foundation

class ApplicationViewModel: ObservableObject {
    
    private var authRepository: AuthRepository
    private var profileRepository: ProfileRepository
    
    init(authRepository: AuthRepository, profileRepository: ProfileRepository) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
    }
    
    @MainActor
    func fetchLastUserSession() async throws -> UserEntity? {
        let (user, userStatus) = try await authRepository.getSession()
        
        guard userStatus == .success, let userSession = user, let userEmail = userSession.email else {
            debugPrint("Previous user not found")
            return nil
        }
        
        let profileRequest = ProfileFetchRequest(profileId: userSession.uid)
        let (profile, profileStatus) = try await profileRepository.fetchProfile(request: profileRequest)
        
        guard profileStatus == .success, let profileSession = profile else {
            debugPrint("Profile not found")
            return nil
        }
        
        return UserEntity(id: userSession.uid.uuidString,
                          name: profileSession.profileName,
                          email: userEmail,
                          balance: profileSession.profileBalance,
                          dateOfBirth: DateUtils.getDatabaseDate(from: profileSession.profileBirthDate) ?? Date()
        )
    }
}
