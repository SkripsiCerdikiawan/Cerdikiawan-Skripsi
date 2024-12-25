//
//  SoundStorageRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 21/11/24.
//

import Foundation

protocol RecordSoundStorageRepository {
    func uploadSoundFile(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus)
    func downloadSound(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus)
}

class SupabaseRecordSoundStorageRepository: StorageRepository, RecordSoundStorageRepository {
    
    // singleton
    public static let shared = SupabaseRecordSoundStorageRepository()
    
    // upload sound data into the storage
    func uploadSoundFile(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus) {
        // create a filePath
        let filePath = "\(request.userId)/\(request.attemptId)"
        // save sound data in the RecordSound bucket of the storage
        try await client.from("RecordSound").upload(filePath, data: request.soundData)
        
        return (SupabaseRecordSound(soundPath: filePath, soundData: request.soundData), .success)
    }
    
    // download sound data from storage
    func downloadSound(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus) {
        // create a filePath
        let filePath = "\(request.userId)/\(request.attemptId)"
        // download sound data from the RecordSound bucket of the storage
        let data = try await client.from("RecordSound").download(path: filePath)
        
        return (SupabaseRecordSound(soundPath: filePath, soundData: data), .success)
    }
    
    
}

