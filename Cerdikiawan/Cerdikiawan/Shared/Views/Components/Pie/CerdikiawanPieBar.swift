//
//  CerdikiawanPieBar.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanPieBar: View {
    let style: CerdikiawanScoreStyle
    
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 100
    let value: CGFloat
    
    var body: some View {
        ZStack {
            // Progress Circle
            Circle()
                .trim(from: 0, to: value / maxValue)
                .stroke(style.foregroundPrimaryColor, lineWidth: 5)
                .rotationEffect(Angle(degrees: -90)) // Start from top
                .frame(width: 65)
            
            Circle()
                .foregroundStyle(style.foregroundSecondaryColor)
                .frame(width: 60)
        }
    }
}

#Preview {
    CerdikiawanPieBar(
        style: .great,
        value: 80
    )
}
