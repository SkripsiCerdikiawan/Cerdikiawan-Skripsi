//
//  SupabaseRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 16/11/24.
//

import Foundation
import Supabase

class SupabaseRepository {
    let client = SupabaseClient(supabaseURL: URL(string: APIKey.dbUrl)!, supabaseKey: APIKey.key)
}
