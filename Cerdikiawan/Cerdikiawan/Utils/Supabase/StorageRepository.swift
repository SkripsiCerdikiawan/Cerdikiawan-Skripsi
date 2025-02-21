//
//  StorageRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 21/11/24.
//

import Foundation
import Supabase

// parent class for storage
class StorageRepository {
    let logger: StorageLogger
    let client: SupabaseStorageClient
    
    init() {
        self.logger = StorageLogger()
        self.client = SupabaseStorageClient(configuration: .init(url: URL(string: "\(APIKey.dbUrl)/storage/v1")!,
                                                                 headers: [
                                                                    "Authorization" : "Bearer \(APIKey.secret)",
                                                                    "apikey": "\(APIKey.key)"
                                                                 ],
                                                                 logger: logger
                                                                ))
    }
}

