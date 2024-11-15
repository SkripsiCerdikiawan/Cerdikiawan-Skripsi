//
//  CerdikiawanReportDetailInformationRow.swift
//  Cerdikiawan
//
//  Created by Hans Arthur Cupiterson on 15/11/24.
//

import SwiftUI

struct CerdikiawanReportDetailInformationRow: View {
    var label: String
    var content: String
    
    var style: CerdikiawanReportDetailInformationRowStyle
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                Text(content)
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(style.backgroundColor)
        .clipShape(style.cornerConfiguration)
    }
}

#Preview {
    ZStack {
        Color(.cGray).ignoresSafeArea()
        VStack(spacing: 4) {
            CerdikiawanReportDetailInformationRow(
                label: "Tingkat Kesulitan",
                content: "Mudah",
                style: .top
            )
            CerdikiawanReportDetailInformationRow(
                label: "Judul Cerita",
                content: "Perjalanan Budi ke Pasar",
                style: .middle
            )
            CerdikiawanReportDetailInformationRow(
                label: "Sinopsis Bacaan",
                content: "Cerita ini menceritakan mengenai bagaimana pengalaman budi berjalan ke pasar",
                style: .bottom
            )
        }
        .padding(.horizontal, 16)
    }
}
