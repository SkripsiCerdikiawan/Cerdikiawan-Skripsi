//
//  ShopRepository.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Foundation

protocol ShopRepository {
    func fetchShopItems() async throws -> ([SupabaseShop], ErrorStatus)
    func fetchShopItemsById(request: ShopRequest) async throws -> (SupabaseShop?, ErrorStatus)
}

class SupabaseShopRepository: SupabaseRepository, ShopRepository {
    
    public static let shared = SupabaseShopRepository()
    private override init() {}
    
    func fetchShopItems() async throws -> ([SupabaseShop], ErrorStatus) {
        let response = try await client
            .from("Shop")
            .select()
            .execute()
        
        guard response.status == 200 else {
            return ([], .serverError)
        }
            
        let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseShop].self)
        
        switch result {
            case .success(let shops):
                guard shops.isEmpty == false else {
                    return ([], .notFound)
                }
                return (shops, .success)
            case .failure(_):
                return ([], .jsonError)
        }
    }
    
    func fetchShopItemsById(request: ShopRequest) async throws -> (SupabaseShop?, ErrorStatus) {
        do {
            guard request.characterShopId != nil else {
                return (nil, .invalidInput)
            }
            
            var query = client
                .from("Shop")
                .select()
            
            if let characterShopId = request.characterShopId {
                query = query
                    .eq("characterShopId", value: characterShopId)
            }
            
            let response = try await query.execute()
            
            guard response.status == 200 else {
                return (nil, .serverError)
            }
            
            let result = JsonManager.shared.loadJSONData(from: response.data, as: [SupabaseShop].self)
            
            switch result {
            case .success(let shop):
                return (shop.first, .success)
            case .failure(_):
                return (nil, .jsonError)
            }
        } catch {
            return (nil, .notFound)
        }
    }
    
    
}
