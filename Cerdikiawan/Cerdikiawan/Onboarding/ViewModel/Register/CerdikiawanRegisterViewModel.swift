//
//  CerdikiawanRegisterViewModel.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import Foundation

class CerdikiawanRegisterViewModel: ObservableObject {
    
    private var authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}
