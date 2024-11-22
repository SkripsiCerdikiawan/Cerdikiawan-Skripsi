//
//  CerdikiawanRegisterView.swift
//  Cerdikiawan
//
//  Created by Nathanael Juan Gauthama on 23/11/24.
//

import SwiftUI

struct CerdikiawanRegisterView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var sessionData: SessionData
    
    @StateObject private var viewModel: CerdikiawanRegisterViewModel
    
    init () {
        _viewModel = .init(
            wrappedValue: .init(
                authRepository: SupabaseAuthRepository.shared
            )
        )
    }
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    CerdikiawanRegisterView()
}
