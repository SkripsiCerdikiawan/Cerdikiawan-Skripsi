//
//  JsonManager.swift
//  StorybookInteractive
//
//  Created by Doni Pebruwantoro on 14/08/24.
//

import Foundation
import Combine

public class JsonManager {
    static let shared = JsonManager()
    
    private init() {}
    
    func loadJSONData<T: Codable>(from data: Data, as type: T.Type) -> Result<T, JsonError> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedData)
        } catch let error as DecodingError {
            return .failure(.decodedFailed(error))
        } catch {
            return .failure(.dataCorrupted)
        }
    }
}
