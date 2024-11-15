//
//  CerdikiawanPieBar.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 14/11/24.
//

import SwiftUI

struct CerdikiawanPieBar: View {
    let minValue: CGFloat = 0
    let maxValue: CGFloat = 100
    let value: CGFloat
    
    @State private var displayedValue: CGFloat = 0
    @State private var style: CerdikiawanScoreStyle = .low
    
    var body: some View {
        ZStack {
            // Progress Circle
            Circle()
                .trim(from: 0, to: displayedValue / maxValue)
                .stroke(style.foregroundPrimaryColor, lineWidth: 5)
                .rotationEffect(Angle(degrees: -90)) // Start from top
                .frame(width: 65)
            
            Circle()
                .foregroundStyle(style.foregroundSecondaryColor)
                .frame(width: 60)
        }
        .onAppear(){
            style = CerdikiawanScoreStyle.determineStyle(value: Int(value))
            // For Animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                Timer.scheduledTimer(
                    withTimeInterval: 1/maxValue,
                    repeats: true) { timer in
                        if displayedValue < value {
                            displayedValue += 1
                        } else {
                            timer.invalidate()
                        }
                    }
            })
        }
    }
}

#Preview {
    CerdikiawanPieBar(
        value: 60
    )
}
