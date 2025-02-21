//
//  ShopTests.swift
//  CerdikiawanTests
//
//  Created by Nathanael Juan Gauthama on 17/11/24.
//

import Testing
@testable import Cerdikiawan
import Foundation

struct ShopTests {
    var shopRepository: ShopRepository
    
    init() async throws {
        shopRepository = SupabaseShopRepository.shared
    }
    
    @Test func testFetchShopItems() async throws {
        let (shops, status) = try await shopRepository.fetchShopItems()
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(!shops.isEmpty,
                "Shops should not be empty"
        )
    }
    
    @Test func testFetchShopItemByCharacterId() async throws {
        let request = ShopRequest(characterShopId: UUID(uuidString: "2b44a843-4115-49bd-9840-e19155b76afe"))
        let (shop, status) = try await shopRepository.fetchShopItemsById(request: request)
        
        #expect(status == .success,
                "Fetching function is not successful"
        )
        
        #expect(shop != nil,
                "Shop should be fetched"
        )
        
        #expect(shop?.characterShopId == request.characterShopId,
                "ShopId does not match"
        )
    }
    
    @Test func testFetchShopItemByInvalidCharacterId() async throws {
        let request = ShopRequest(characterShopId: UUID(uuidString: "wrong id"))
        let (shop, status) = try await shopRepository.fetchShopItemsById(request: request)
        
        #expect(shop == nil &&
                status == .invalidInput,
                "Input must be invalid"
        )
    }
}
