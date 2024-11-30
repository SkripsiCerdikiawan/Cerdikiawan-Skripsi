//
//  RecordSoundTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 21/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct RecordSoundTests {
    var recordSoundRepository: RecordSoundStorageRepository
//    var authhRepository: AuthRepository
    
    init() async throws {
        recordSoundRepository = SupabaseRecordSoundStorageRepository.shared
//        authhRepository = SupabaseAuthRepository.shared
    }
    
    @Test func testUploadRecordSound() async throws {
        
        guard let profileId = UUID(uuidString: "2414c7e0-414c-4353-807f-200d009aace8") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        
        guard let attemptId = UUID(uuidString: "d6d1d27a-4d1c-45aa-978c-fd361d69aef2") else {
            #expect(Bool(false), "Invalid attemptId")
            return
        }
        
        let fileName = "SampleSound"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            #expect(Bool(false), "MP3 file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let request = RecordSoundRequest(userId: profileId, attemptId: attemptId, soundData: data)
            let (fileName, status) = try await recordSoundRepository.uploadSoundFile(request: request)
            
            #expect(status == .success, "Upload sound not successful")
            #expect(fileName != nil, "File name empty")
            #expect(fileName?.soundPath == "\(profileId)/\(attemptId).mp3", "File name is not correct")
        } catch {
            #expect(Bool(false), "Error uploading sound file: \(error.localizedDescription)")
            
        }
    }
    
    @Test func testDownloadRecordedSound() async throws {
        guard let profileId = UUID(uuidString: "9EBD74DB-A0F0-4338-841A-36DB80FA6AA7") else {
            #expect(Bool(false), "Invalid profileId")
            return
        }
        
        guard let attemptId = UUID(uuidString: "EE53615A-A74F-4139-8A32-290A613566DC") else {
            #expect(Bool(false), "Invalid attemptId")
            return
        }
        
        let request = RecordSoundRequest(userId: profileId, attemptId: attemptId, soundData: Data())
        let (sound, status) = try await recordSoundRepository.downloadSound(request: request)
        
        #expect(status == .success, "Failed to download recorded sound")
        #expect(sound?.soundData != nil, "Downloaded sound is nil")
        
        let fileName = "SampleSound"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            #expect(Bool(false), "MP3 file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            #expect(sound?.soundData == data, "Downloaded sound data does not match expected data")
        } catch {
            #expect(Bool(false), "Error uploading sound file: \(error.localizedDescription)")
        }
    }
}
