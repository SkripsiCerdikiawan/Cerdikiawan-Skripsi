//
//  SupabaseHelper.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 14/11/24.
//

import Foundation
import Supabase

class SupabaseDatabaseRepository {
    
    let client = SupabaseClient(supabaseURL: URL(string: APIKey.dbUrl)!, supabaseKey: APIKey.key)
    
    init() {}
    
}
