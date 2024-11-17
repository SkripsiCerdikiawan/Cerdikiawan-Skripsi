//
//  ProfileTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct ProfileTests {
    var profileRepository: ProfileRepository
    
    init() async throws {
        profileRepository = SupabaseProfileRepository.shared
    }

    @Test func fetchProfile() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileFetchRequest(profileId: profileId)
        let (profile, status) = try await profileRepository.fetchProfile(request: request)
        
        #expect(status == .success, "Failed to fetch profile")
        #expect(profile != nil, "Profile is nil")
    }
    
    @Test func insertNewProfile() async throws {
        guard let profileId = UUID(uuidString: "c96ea4c9-34a1-4c83-84f7-ad9e269de2f3") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileInsertRequest(profileId: profileId,
                                           profileName: "Hans",
                                           profileBalance: 0,
                                           profileBirthDate: "2003-12-12"
        )
        
        let (profile, status) = try await profileRepository.createNewProfile(request: request)
        
        #expect(status == .success, "Failed to insert new profile")
        #expect(profile != nil, "Profile is nil")
    }
    
}
