//
//  CerdikiawanReportSummary.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanReportSummary: View {
    var value: Int
    var minValue: Int = 0
    var maxValue: Int = 100
    
    @State var style: CerdikiawanScoreStyle = .normal
    @State var status: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Status Pemahaman Membaca")
                        .font(.subheadline)
                    Text(status)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(style.foregroundPrimaryColor)
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                CerdikiawanPieBar(
                    value: CGFloat(value)
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.cWhite))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .onAppear(){
            style = CerdikiawanScoreStyle.determineStyle(value: value)
            status = getStatus()
        }
    }
    
    func getStatus() -> String {
        switch self.value {
        case -1..<25:
            return "KURANG"
        case 25..<75:
            return "CUKUP"
        case 75..<90:
            return "BAIK"
        case 90..<101:
            return "SANGAT BAIK"
        default:
            return "Error"
        }
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        CerdikiawanReportSummary(
            value: 90
        )
        .padding(.horizontal, 16)
        
    }
}
