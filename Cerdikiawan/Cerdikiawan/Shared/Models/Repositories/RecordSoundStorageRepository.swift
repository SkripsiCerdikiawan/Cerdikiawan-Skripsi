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
    
    public static let shared = SupabaseRecordSoundStorageRepository()
    
    func uploadSoundFile(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus) {
        let filePath = "\(request.userId)/\(request.attemptId)"
        try await client.from("RecordSound").upload(filePath, data: request.soundData)
        
        return (SupabaseRecordSound(soundPath: filePath, soundData: request.soundData), .success)
    }
    
    func downloadSound(request: RecordSoundRequest) async throws -> (SupabaseRecordSound?, ErrorStatus) {
        let filePath = "\(request.userId)/\(request.attemptId)"
        let data = try await client.from("RecordSound").download(path: filePath)
        return (SupabaseRecordSound(soundPath: filePath, soundData: data), .success)
    }
    
    
}

