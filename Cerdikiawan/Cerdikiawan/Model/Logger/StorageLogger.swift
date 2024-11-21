//
//  StorageLogger.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 21/11/24.
//

import Foundation
import Supabase

class StorageLogger: SupabaseLogger, @unchecked Sendable {
    func log(message: SupabaseLogMessage) {
        print(message.description)
    }
}
