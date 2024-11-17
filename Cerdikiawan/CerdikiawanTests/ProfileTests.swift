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

    @Test func testFetchProfile() async throws {
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileFetchRequest(profileId: profileId)
        let (profile, status) = try await profileRepository.fetchProfile(request: request)
        
        #expect(status == .success, "Failed to fetch profile")
        #expect(profile != nil, "Profile is nil")
    }
    
    @Test func testDeleteProfile() async throws {
        guard let profileId = UUID(uuidString: "d7e08c6a-e80e-4288-9675-69dd454c14d8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let deleteRequest = ProfileDeleteRequest(profileId: profileId)
        let (deleteStatus) = try await profileRepository.deleteProfile(request: deleteRequest)
        
        #expect(deleteStatus == .success, "Failed to delete profile")
        
        let fetchRequest = ProfileFetchRequest(profileId: profileId)
        let (profile, fetchStatus) = try await profileRepository.fetchProfile(request: fetchRequest)
        
        #expect(profile == nil && fetchStatus == .notFound, "Profile still exists")
    }
    
    @Test func testInsertNewProfile() async throws {
        guard let profileId = UUID(uuidString: "d7e08c6a-e80e-4288-9675-69dd454c14d8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileInsertRequest(profileId: profileId,
                                           profileName: "Rizky",
                                           profileBalance: 0,
                                           profileBirthDate: "2006-04-10"
        )
        
        let (profile, status) = try await profileRepository.createNewProfile(request: request)
        
        #expect(status == .success, "Failed to insert new profile")
        #expect(profile != nil, "Profile is nil")
    }
    
    @Test func testUpdateProfileSuccess() async throws {
        guard let profileId = UUID(uuidString: "c96ea4c9-34a1-4c83-84f7-ad9e269de2f3") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileUpdateRequest(profileId: profileId,
                                           profileName: "Hans Cupiterson",
                                           profileBalance: 10,
                                           profileBirthDate: "2003-12-13"
        )
        
        let (profile, status) = try await profileRepository.updateProfile(request: request)
        
        #expect(status == .success, "Unexpected status: \(status)")
        #expect(profile != nil, "Profile should not be nil")
        
        if let updatedProfile = profile, status == .success {
            #expect(updatedProfile.profileId == request.profileId, "Invalid profileId")
            if request.profileName != nil {
                #expect(updatedProfile.profileName == request.profileName, "Profile name did not updated")
            }
            if request.profileBalance != nil {
                #expect(updatedProfile.profileBalance == request.profileBalance, "Profile balance did not updated")
            }
            if request.profileBirthDate != nil {
                #expect(updatedProfile.profileBirthDate == request.profileBirthDate, "Profile birth date did not updated")
            }
        } else {
            #expect(Bool(false), "Profile should not be nil")
        }
    }
    
    @Test func testUpdateProfileOneAttribute() async throws {
        guard let profileId = UUID(uuidString: "9ebd74db-a0f0-4338-841a-36db80fa6aa7") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        let request = ProfileUpdateRequest(profileId: profileId,
                                           profileBalance: 99
        )
        
        let (profile, status) = try await profileRepository.updateProfile(request: request)
        
        #expect(status == .success, "Unexpected status: \(status)")
        #expect(profile != nil, "Profile should not be nil")
        
        if let updatedProfile = profile, status == .success {
            #expect(updatedProfile.profileId == request.profileId, "Invalid profileId")
            if request.profileName != nil {
                #expect(updatedProfile.profileName == request.profileName, "Profile name did not updated")
            }
            if request.profileBalance != nil {
                #expect(updatedProfile.profileBalance == request.profileBalance, "Profile balance did not updated")
            }
            if request.profileBirthDate != nil {
                #expect(updatedProfile.profileBirthDate == request.profileBirthDate, "Profile birth date did not updated")
            }
        } else {
            #expect(Bool(false), "Profile should not be nil")
        }
    }
}
