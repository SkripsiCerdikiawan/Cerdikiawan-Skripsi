//
//  CerdikiawanProgressBar.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 13/11/24.
//

import SwiftUI

struct CerdikiawanProgressBar: View {
    let minimum: Double
    let maximum: Double
    @Binding var value: Int
    
    @State private var style: CerdikiawanProgressBarStyle = .empty
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: style.height)
                    .foregroundStyle(
                        style.backgroundColor
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )
                
                Rectangle()
                    .frame(width: calculateBarWidth(totalWidth: geometry.size.width), height: style.height)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 4)
                    )
                    .foregroundStyle(style.barColor)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: style.height)
        .onAppear {
            changeStyle()
        }
        .onChange(of: value) {
            changeStyle()
        }
    }
    
    func calculateBarWidth(totalWidth: CGFloat) -> CGFloat {
        let percentage = (Double(value) - minimum) / (maximum - minimum)
        let clampedPercentage = min(max(percentage, 0), 1)
        return totalWidth * CGFloat(clampedPercentage)
    }
    
    func changeStyle() {
        if Double(value) <= minimum {
            self.style = .empty
        } else if Double(value) >= maximum {
            self.style = .complete
        } else {
            self.style = .filled
        }
    }
}


#Preview {
    @Previewable
    @State var value: Int = 0
    
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack {
            CerdikiawanProgressBar(
                minimum: 0,
                maximum: 20,
                value: $value
            )
        }
        .padding(.horizontal, 16)
        .onAppear(){
            Timer.scheduledTimer(
                withTimeInterval: 1,
                repeats: value < 20,
                block: { timer in
                    if value < 20 {
                        value += 1
                    } else {
                        timer.invalidate()
                    }
                })
        }
    }
}
